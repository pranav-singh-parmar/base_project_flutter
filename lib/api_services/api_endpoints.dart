import '../constants_and_extenstions/app_constants.dart';

abstract class APIEndpoints {
  String get baseURL;
  String get apiMidPoint;
  String get endpoint;
  String get getURL => "$baseURL$endpoint"; // Default implementation
}

class ApiEndPoints {
  static const anime = "${AppUrls.apiMidPoint}anime";
}

enum AnimeEndpoints implements APIEndpoints {
  anime("anime");

  @override
  String get baseURL => AppDomain.baseURL;

  @override
  String get apiMidPoint => AppUrls.apiMidPoint;

  @override
  final String endpoint;

  const AnimeEndpoints(this.endpoint);

  // @override
  // String get endpoint {
  //   switch (this) {
  //     case ApiEndPoints.connect:
  //       return "connect";
  //     case ApiEndPoints.speedtest:
  //       return "speedtest";
  //   }
  // }

  @override
  String get getURL =>
      "$baseURL$apiMidPoint$endpoint"; // Default implementation
}

// sealed class AppServerEndpoints implements APIEndpoints {
//   const AppServerEndpoints();

//   @override
//   String get baseURL => AppUrls.apiBaseURL;
//   @override
//   String get getURL => "$baseURL$endpoint";
//   @override
//   String get endpoint;
// }
