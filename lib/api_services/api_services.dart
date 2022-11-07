import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'models/models_used_to_send_data/ImageModel.dart';
import '../constants_and_extenstions/singleton.dart';
import 'package:http/http.dart' as http;
import '../constants_and_extenstions/app_constants.dart'
    show AppUrls, HttpMehod, ParameterEncoding, SharedPrefsKeys, AppStrings;
import '../constants_and_extenstions/extensions.dart';

class ApiServices {
  StreamSubscription? subcription;

  Map<String, String> getHeaders(bool isAuthApi) {
    final Map<String, String> headers = {"Content-Type": 'application/json'};
    // if using third party api's then no need to send token in it
    if (isAuthApi) {
      headers["Authorization"] =
          Singleton.instance.sharedPrefs.getString(SharedPrefsKeys.authToken);
    }

    return headers;
  }

  String? getJsonBody(Map<String, String>? parameters) {
    if (parameters != null) {
      return jsonEncode(parameters);
    }
    return null;
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

      late final String? jsonBody;

      if (!isQueryParameters) {
        jsonBody = jsonEncode(parameters);
      }

      final Map<String, String> headers = getHeaders(isAuthApi);

      "httpMethod --> $httpMethod".log();
      "uri --> $uri".log();
      "headers --> $headers".log();
      "parameterEncoding --> $parameterEncoding".log();
      "parameters --> $parameters".log();

      late final http.Response response;
      switch (httpMethod) {
        case HttpMehod.get:
          response = await http.get(uri, headers: headers);
          break;
        case HttpMehod.post:
          if (imageModel.isEmpty) {
            response = await http.post(uri, headers: headers, body: jsonBody);
          } else {
            final request = http.MultipartRequest("POST", uri);
            if (parameters != null) {
              request.fields.addAll(parameters.toMapStringString());
            }
            request.headers.addAll(headers);
            for (final imageModel in imageModel) {
              request.files.add(http.MultipartFile.fromBytes(
                  imageModel.paramName ?? "",
                  File(imageModel.image?.path ?? "").readAsBytesSync(),
                  filename: imageModel.paramName ?? ""));
            }
            http.StreamedResponse streamResponse = await request.send();
            response = await http.Response.fromStream(streamResponse);
          }
          break;
        case HttpMehod.put:
          response = await http.put(uri, headers: headers, body: jsonBody);
          break;
        case HttpMehod.delete:
          response = await http.delete(uri, headers: headers, body: jsonBody);
          break;
        case HttpMehod.patch:
          response = await http.patch(uri, headers: headers, body: jsonBody);
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
      Singleton.instance.generalFunctions.showToast(AppStrings.internetNotConnected);
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
