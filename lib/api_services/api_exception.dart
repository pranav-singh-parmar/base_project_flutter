import 'package:flutter/foundation.dart';

enum ApiErrorType {
  packageError,
  noInternet,
  lostInternetConnection,
  timeout,
  unknown
}

enum HTTPStatusType {
  informationalError, // 100...199
  // success, //200..299
  redirectionError, // 300...399
  clientError, // 400...499
  serverError, // 500...599
  unknown
}

class ApiException implements Exception {
  final ApiErrorType type;
  final String message;

  ApiException(this.type, this.message);

  @override
  String toString() => 'ApiException ($type): $message';
}

@immutable
sealed class APIResult {
  const APIResult();
}

class Success extends APIResult {
  final int statusCode;
  final dynamic json;
  final dynamic response;

  const Success({
    required this.statusCode,
    required this.json,
    required this.response,
  });
}

class HTTPStatusFailure extends APIResult {
  final int statusCode;
  final HTTPStatusType statusType;
  final dynamic json;
  final dynamic response;

  const HTTPStatusFailure({
    required this.statusCode,
    required this.statusType,
    required this.json,
    required this.response,
  });
}

class HTTPStatusClientFailure extends APIResult {
  final int statusCode;
  final ClientErrorsEnum errorType;
  final dynamic json;
  final dynamic response;

  const HTTPStatusClientFailure({
    required this.statusCode,
    required this.errorType,
    required this.json,
    required this.response,
  });
}

class Failure extends APIResult {
  final ApiErrorType apiErrorType;
  final String message;

  const Failure({
    required this.apiErrorType,
    required this.message,
  });
}

// Equivalent of ClientErrorsEnum
enum ClientErrorsEnum {
  badRequest, // 400
  unauthorised, // 401
  paymentRequired, // 402
  forbidden, // 403
  notFound, // 404
  methodNotAllowed, // 405
  notAcceptable, // 406
  uriTooLong, // 414
  other, // other codes
}
