enum HttpMehod { get, post, put, delete }

enum ParameterEncoding {
  none,
  formURLEncoded,
  jsonBody,
  formData,
  // imageUpload
}

enum JsonDecoderEnum { none, razorPayTokenReponse }

enum JsonStructEnum { onlyModel, onlyJson, both }

enum ApiStatus { notHitOnce, isBeingHit, apiHit, apiHitWithError }

class AppDomain {
  static const bool isHTTPS = true;
  static const String baseURL = "https://anime-db.p.rapidapi.com";
}

class AppUrls {
  static const String apiBaseURL = AppDomain.baseURL;
  static const String apiMidPoint = "";
  static const String privacyPolicy = "${AppDomain.baseURL}/privacypolicy";
}

class ApiEndPoints {
  static const anime = "${AppUrls.apiMidPoint}anime";
}

class AppColors {}

class SharedPrefsKeys {
  static const fcmToken = "fcmToken";
  static const authToken = "authToken";
}
