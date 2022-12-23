import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'models/models_used_to_send_data/ImageModel.dart';
import '../constants_and_extenstions/singleton.dart';
import 'package:http/http.dart' as http;
import '../constants_and_extenstions/app_constants.dart'
    show AppUrls, HttpMehod, ParameterEncoding, SharedPrefsKeys;
import '../constants_and_extenstions/extensions.dart';

class ApiServices {
  StreamSubscription? subcription;

  Map<String, String> _getHeaders(bool isAuthApi) {
    final Map<String, String> headers = {"Content-Type": 'application/json'};
    // if using third party api's then no need to send token in it
    if (isAuthApi) {
      headers["Authorization"] =
          Singleton.instance.sharedPrefs.getString(SharedPrefsKeys.authToken);
    }

    return headers;
  }

  Uri getUri(String baseURL, String endPoint, bool isParameterEncoding,
      Map<String, dynamic>? parameters) {
    if (isParameterEncoding && parameters != null) {
      final parametersAsString = parameters.toMapStringString();
      if (baseURL.substring(0, 5) == "https") {
        final urlWithoutHttps = baseURL.replaceFirst("https://", "");
        return Uri.https(urlWithoutHttps, endPoint, parametersAsString);
      }
      final urlWithoutHttp = baseURL.replaceFirst("http://", "");
      return Uri.http(urlWithoutHttp, endPoint, parametersAsString);
    } else {
      return Uri.parse(baseURL + endPoint);
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

  dynamic hitApi(
      {HttpMehod httpMethod = HttpMehod.get,
      String baseURL = AppUrls.apiBaseURL,
      String endPoint = "",
      bool isAuthApi = false,
      ParameterEncoding parameterEncoding = ParameterEncoding.none,
      Map<String, dynamic>? parameters,
      List<ImageModel> imageModel = const [],
      Function? whenInternotNotConnected}) async {
    if (Singleton.instance.internetConnectivity.isInternetConnected) {
      if (subcription != null) {
        subcription?.cancel();
      }
      final bool isQueryParameters =
          parameterEncoding == ParameterEncoding.queryParameters;

      final Uri uri = getUri(baseURL, endPoint, isQueryParameters, parameters);

      final Map<String, String> headers = _getHeaders(isAuthApi);

      "httpMethod --> $httpMethod".log();
      "uri --> $uri".log();
      "headers --> $headers".log();
      "parameterEncoding --> $parameterEncoding".log();
      "parameters --> $parameters".log();

      //https://pub.dev/documentation/http/latest/http/post.html
      late final dynamic body;
      switch (parameterEncoding) {
        case ParameterEncoding.jsonBody:
          body = jsonEncode(parameters);
          break;
        case ParameterEncoding.formURLEncoded:
          //If body is a Map, it's encoded as form fields using encoding.
          //The content-type of the request will be set to "application/x-www-form-urlencoded";
          //this cannot be overridden.
          body = parameters;
          break;
        default:
          body = null;
          break;
      }

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
            response =
                await _uploadFiles("PUT", uri, headers, parameters, imageModel);
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

      switch (response.statusCode) {
        case 401:
        //routeOnBoard
        default:
          try {
            return jsonDecode(response.body);
          } catch (exception) {
            "error in $uri --> $exception".log();
          }
      }
    } else {
      //Singleton.instance.generalFunctions.showToast(interetNotConnected);
      // Singleton.instance.generalFunctions.showInternetNotConnectedDialog(context, () { if (whenInternotNotConnected != null) {
      //       whenInternotNotConnected();
      //       subcription?.cancel();
      //     } })
      if (subcription != null) {
        subcription = Singleton
            .instance.internetConnectivity.checkInternetConnectionStream
            .listen((bool isConnectedToInternet) async {
          if (isConnectedToInternet) {
            if (whenInternotNotConnected != null) {
              whenInternotNotConnected();
            }
            subcription?.cancel();
          }
        });
      }
    }

    return null;
  }
}
