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
  success, //200..299
  redirectionError, // 300...399
  clientError, // 400...499
  serverError, // 500...599
  unknown
}

@immutable
sealed class APIResult {
  const APIResult();
}

class SuccessAPIResult extends APIResult {
  final int statusCode;
  final HTTPStatusType statusType = HTTPStatusType.success;
  final dynamic json;
  final dynamic response;

  const SuccessAPIResult({
    required this.statusCode,
    required this.json,
    required this.response,
  });
}

class HTTPStatusFailureAPIResult extends APIResult {
  final int statusCode;
  final HTTPStatusType statusType;
  final String message;
  final dynamic json;
  final dynamic response;

  const HTTPStatusFailureAPIResult({
    required this.statusCode,
    required this.statusType,
    required this.message,
    required this.json,
    required this.response,
  });
}

class HTTPStatusClientFailureAPIResult extends APIResult {
  final int statusCode;
  final HTTPStatusType statusType = HTTPStatusType.clientError;
  final ClientErrorsEnum errorType;
  final String message;
  final dynamic json;
  final dynamic response;

  const HTTPStatusClientFailureAPIResult({
    required this.statusCode,
    required this.errorType,
    required this.message,
    required this.json,
    required this.response,
  });
}

class FailureAPIResult extends APIResult {
  final ApiErrorType apiErrorType;
  final String message;

  const FailureAPIResult({
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
