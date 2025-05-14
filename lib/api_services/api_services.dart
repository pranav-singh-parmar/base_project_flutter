import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants_and_extenstions/app_constants.dart';
import '../constants_and_extenstions/internect_connectivity.dart';
import '../constants_and_extenstions/nonui_extensions.dart';
import 'api_endpoints.dart';
import 'api_result.dart';
import 'models/models_used_to_send_data/image_model.dart';

class ApiServices {
  Map<String, String> _getHeaders(Map<String, String>? extraHeaders) {
    final Map<String, String> headers = {};
    // if using third party api's then no need to send token in it
    if (extraHeaders != null) headers.addAll(extraHeaders);

    return headers;
  }

  Uri getUri(
      {required APIEndpoints apiEndpoint,
      Map<String, dynamic>? queryparameters}) {
    if (queryparameters != null) {
      final baseURL = apiEndpoint.baseURL.removeLastChar();
      final midPointAndEndpoint =
          "${apiEndpoint.apiMidPoint}${apiEndpoint.endpoint}";
      final endPoint =
          midPointAndEndpoint.isEmpty ? "" : "/$midPointAndEndpoint";
      final parametersAsString = queryparameters.toMapStringString();
      if (baseURL.substring(0, 5) == "https") {
        final urlWithoutHttps = baseURL.replaceFirst("https://", "");
        return Uri.https(urlWithoutHttps, endPoint, parametersAsString);
      }
      final urlWithoutHttp = baseURL.replaceFirst("http://", "");
      return Uri.http(urlWithoutHttp, endPoint, parametersAsString);
    } else {
      return Uri.parse(apiEndpoint.getURL);
    }
  }

  Future<http.Response> _uploadFiles(
      String httpMethod,
      Uri uri,
      Map<String, String> headers,
      Map<String, dynamic>? parameters,
      List<ImageModel> imageModel) async {
    final request = http.MultipartRequest(httpMethod, uri);
    if (parameters != null) {
      request.fields.addAll(parameters.toMapStringString());
    }
    request.headers.addAll(headers);
    for (final imageModel in imageModel) {
      request.files.add(http.MultipartFile.fromBytes(imageModel.paramName ?? "",
          File(imageModel.image?.path ?? "").readAsBytesSync(),
          filename: imageModel.paramName ?? ""));
    }
    http.StreamedResponse streamResponse = await request.send();
    return await http.Response.fromStream(streamResponse);
  }

  Future<APIResult> hitApi(
      {required HttpMehod httpMethod,
      required uri,
      bool isAuthApi = false,
      Map<String, String>? extraHeaders,
      ParameterEncoding parameterEncoding = ParameterEncoding.none,
      Map<String, dynamic>? parameters,
      List<ImageModel> imageModel = const [],
      Function? whenInternotNotConnected}) async {
    if (InternetConnectivity().isInternetConnected) {
      final Map<String, String> headers = _getHeaders(extraHeaders);

      "httpMethod --> $httpMethod".log();
      "uri --> $uri".log();
      "queryParameters --> ${uri.queryParameters}".log();
      "headers --> $headers".log();
      "parameterEncoding --> $parameterEncoding".log();
      "parameters --> $parameters".log();

      //https://pub.dev/documentation/http/latest/http/post.html
      late final dynamic body;
      if (parameters != null) {
        switch (parameterEncoding) {
          case ParameterEncoding.jsonBody:
            body = jsonEncode(parameters);
            headers.addAll({
              "Content-Type": "application/json",
            });
            break;
          case ParameterEncoding.formURLEncoded:
            //If body is a Map, it's encoded as form fields using encoding.
            //The content-type of the request will be set to "application/x-www-form-urlencoded";
            //this cannot be overridden.
            body = parameters.map(
              (key, value) => MapEntry(
                key,
                Uri.encodeComponent(value),
              ),
            );
            headers.addAll({
              "Content-Type": "application/x-www-form-urlencoded",
            });
            break;
          default:
            body = null;
            break;
        }
      } else {
        body = null;
      }
      try {
        final http.Response response;
        switch (httpMethod) {
          case HttpMehod.get:
            response = await http.get(uri, headers: headers);
            break;
          case HttpMehod.post:
            if (imageModel.isEmpty) {
              response = await http.post(uri, headers: headers, body: body);
            } else {
              response = await _uploadFiles(
                  "POST", uri, headers, parameters, imageModel);
            }
            break;
          case HttpMehod.put:
            if (imageModel.isEmpty) {
              response = await http.put(uri, headers: headers, body: body);
            } else {
              response = await _uploadFiles(
                  "PUT", uri, headers, parameters, imageModel);
            }
            break;
          case HttpMehod.delete:
            if (imageModel.isEmpty) {
              response = await http.delete(uri, headers: headers, body: body);
            } else {
              response = await _uploadFiles(
                  "DELETE", uri, headers, parameters, imageModel);
            }
            break;
        }

        final statusCode = response.statusCode;
        "statusCode --> $statusCode".log();
        dynamic json;
        try {
          json = jsonDecode(response.body);
          "json --> $parameters".log();
        } catch (exception) {
          "error in $uri --> $exception".log();
          json = null;
        }

        if (statusCode >= 100 && statusCode <= 199) {
          return HTTPStatusFailureAPIResult(
            statusCode: statusCode,
            statusType: HTTPStatusType.informationalError,
            message: _getErrorMessage(json),
            json: json,
            response: response.body,
          );
        } else if (statusCode >= 200 && statusCode <= 299) {
          return SuccessAPIResult(
            statusCode: statusCode,
            json: json,
            response: response.body,
          );
        } else if (statusCode >= 300 && statusCode <= 399) {
          return HTTPStatusFailureAPIResult(
            statusCode: statusCode,
            statusType: HTTPStatusType.redirectionError,
            message: _getErrorMessage(json),
            json: json,
            response: response.body,
          );
        } else if (statusCode >= 400 && statusCode <= 499) {
          final ClientErrorsEnum clientErrorType;
          if (statusCode == 400) {
            clientErrorType = ClientErrorsEnum.badRequest;
          } else if (statusCode == 401) {
            clientErrorType = ClientErrorsEnum.unauthorised;
          } else if (statusCode == 402) {
            clientErrorType = ClientErrorsEnum.paymentRequired;
          } else if (statusCode == 401) {
            clientErrorType = ClientErrorsEnum.unauthorised;
          } else if (statusCode == 403) {
            clientErrorType = ClientErrorsEnum.forbidden;
          } else if (statusCode == 404) {
            clientErrorType = ClientErrorsEnum.notFound;
          } else if (statusCode == 405) {
            clientErrorType = ClientErrorsEnum.methodNotAllowed;
          } else if (statusCode == 406) {
            clientErrorType = ClientErrorsEnum.notAcceptable;
          } else if (statusCode == 414) {
            clientErrorType = ClientErrorsEnum.uriTooLong;
          } else {
            clientErrorType = ClientErrorsEnum.other;
          }

          return HTTPStatusClientFailureAPIResult(
            statusCode: statusCode,
            errorType: clientErrorType,
            message: _getErrorMessage(json),
            json: json,
            response: response.body,
          );
        } else if (statusCode >= 500 && statusCode <= 599) {
          return HTTPStatusFailureAPIResult(
            statusCode: statusCode,
            statusType: HTTPStatusType.serverError,
            message: _getErrorMessage(json),
            json: json,
            response: response.body,
          );
        } else {
          return HTTPStatusFailureAPIResult(
            statusCode: statusCode,
            statusType: HTTPStatusType.unknown,
            message: _getErrorMessage(json),
            json: json,
            response: response.body,
          );
        }
      } on http.ClientException {
        return const FailureAPIResult(
          apiErrorType: ApiErrorType.packageError,
          message: "Error in HTTP Package",
        );
      } on SocketException {
        return const FailureAPIResult(
          apiErrorType: ApiErrorType.lostInternetConnection,
          message: "Lost internet connection",
        );
      } on TimeoutException {
        return const FailureAPIResult(
          apiErrorType: ApiErrorType.timeout,
          message: "Request timed out",
        );
      } catch (e) {
        return const FailureAPIResult(
          apiErrorType: ApiErrorType.unknown,
          message: "Unknown",
        );
      }
    } else {
      return const FailureAPIResult(
        apiErrorType: ApiErrorType.noInternet,
        message: "No Internet Connection",
      );
    }
  }

  String _getErrorMessage(dynamic json) {
    if (json['message'] is String) {
      return json['message'];
    } else if (json['error'] is String) {
      return json['error'];
    } else if (json['error'] is List) {
      List<dynamic> errorMessages = json['error'];
      String errorMessage = errorMessages.join(', ');
      return errorMessage;
    } else {
      return "Server Error";
    }
  }
}
