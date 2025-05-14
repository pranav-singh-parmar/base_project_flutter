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
  static const String baseURL = "https://anime-db.p.rapidapi.com/";
}

class AppUrls {
  static const String apiBaseURL = AppDomain.baseURL;
  static const String apiMidPoint = "";
  static const String privacyPolicy = "${AppDomain.baseURL}/privacypolicy";
}

enum SharedPrefsKeys {
  fcmToken("fcm_token"),
  authToken("auth_token"),
  theme("theme"),
  speedBeforeVPN("speed_test_model_without_vpn"),
  speedAfterVPN("speed_test_model_with_vpn"),
  purchaseDetails("purchase_details"),
  userDetails("user_details"),
  ;

  final String value;
  const SharedPrefsKeys(this.value);
}
