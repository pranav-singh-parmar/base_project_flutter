import '../api_result.dart';

sealed class RepositoryResult<T> {
  const RepositoryResult();
}

class SuccessRepositoryResult<T> extends RepositoryResult<T> {
  final T data;

  const SuccessRepositoryResult({
    required this.data,
  });
}

class InternetNotConnectedRepositoryResult extends RepositoryResult<Never> {}

class InternetConnectionLostRepositoryResult extends RepositoryResult<Never> {}

class TimeOutRepositoryResult extends RepositoryResult<Never> {}

class DecodingErrorRepositoryResult extends RepositoryResult {
  final String decodingErrorString;

  const DecodingErrorRepositoryResult({
    required this.decodingErrorString,
  });
}

class UnauthorisedRepositoryResult extends RepositoryResult<Never> {
  final String message;

  const UnauthorisedRepositoryResult({
    required this.message,
  });
}

class ValidationFailedRepositoryResult extends RepositoryResult<Never> {
  final int statusCode;
  final HTTPStatusType statusType;
  final dynamic json;
  final String message;

  const ValidationFailedRepositoryResult({
    required this.statusCode,
    required this.statusType,
    required this.json,
    required this.message,
  });
}

class OtherRepositoryResult extends RepositoryResult<Never> {
  final int statusCode;
  final HTTPStatusType statusType;
  final dynamic json;
  final String message;

  const OtherRepositoryResult({
    required this.statusCode,
    required this.statusType,
    required this.json,
    required this.message,
  });
}

class UnknownRepositoryResult extends RepositoryResult<Never> {
  final String message;

  const UnknownRepositoryResult({
    required this.message,
  });
}

class CustomRepositoryResult<T> extends RepositoryResult<Never> {
  final int statusCode;
  final HTTPStatusType statusType;
  final T reason;
  final dynamic json;

  const CustomRepositoryResult({
    required this.statusCode,
    required this.statusType,
    required this.reason,
    required this.json,
  });
}
