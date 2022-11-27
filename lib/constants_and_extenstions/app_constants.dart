enum HttpMehod { get, post, put, delete, patch }

enum ParameterEncoding {
  none,
  queryParameters,
  jsonBody,
  // formData,
  // imageUpload
}

enum JsonDecoderEnum { none, razorPayTokenReponse }

enum JsonStructEnum { onlyModel, onlyJson, both }

enum ApiStatus { notHitOnce, isBeingHit, apiHit, apiHitWithError }

class AppDomain {
  static const bool isHTTPS = true;
  static const String baseURL = "https://www.breakingbadapi.com";
}

class AppUrls {
  static const String apiBaseURL = AppDomain.baseURL;
  static const String apiMidPoint = "/api/";
  static const String privacyPolicy = "${AppDomain.baseURL}/privacypolicy";
}

class ApiEndPoints {
  static const characters = "${AppUrls.apiMidPoint}characters";
}

class AppColors {}

class SharedPrefsKeys {
  static const fcmToken = "fcmToken";
  static const authToken = "authToken";
}
