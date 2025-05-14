import '../../constants_and_extenstions/app_constants.dart';
import '../../constants_and_extenstions/extensions.dart';
import '../api_endpoints.dart';
import '../api_result.dart';
import '../api_services.dart';
import '../models/anime_list_response.dart';
import 'repository.dart';
import 'repository_result.dart';

enum AnimeRespositoryResultEnum {
  noMoreHits;
}

class AnimeRepository extends BaseRepository {
  //return custom type for this function
  Future<RepositoryResult<AnimeListResponse>> getAnimeList({
    required String search,
    required int page,
    int size = 10,
  }) async {
    final apiService = ApiServices();
    final queryparameters = {"page": page, "size": size, "search": search};
    final uri = apiService.getUri(
        apiEndpoint: AnimeEndpoints.anime, queryparameters: queryparameters);
    final headers = {
      "X-RapidAPI-Key": "2b975442demsh14dd8bb5a692b60p17c702jsnc458dbd221ae",
      "X-RapidAPI-Host": "anime-db.p.rapidapi.com"
    };

    final apiResult = await apiService.hitApi(
      httpMethod: HttpMehod.get,
      uri: uri,
      extraHeaders: headers,
      // parameterEncoding: ParameterEncoding.jsonBody,
      // parameters: {},
    );

    switch (apiResult) {
      case SuccessAPIResult(:final statusCode, :final statusType, :final json):
        if (statusCode == 200) {
          'Success with data: $json'.log();
          final model = AnimeListResponse.fromJson(json);

          return SuccessRepositoryResult(data: model);
        } else if (statusCode == 250) {
          return CustomRepositoryResult<AnimeRespositoryResultEnum>(
            statusCode: statusCode,
            statusType: statusType,
            json: json,
            reason: AnimeRespositoryResultEnum.noMoreHits,
          );
        } else {
          return ValidationFailedRepositoryResult(
            statusCode: statusCode,
            statusType: statusType,
            json: json,
            message: getErrorMessage(json),
          );
        }
      case HTTPStatusFailureAPIResult(
          :final statusCode,
          :final statusType,
          :final message,
          :final json,
        ):
        return OtherRepositoryResult(
          statusCode: statusCode,
          statusType: statusType,
          message: message,
          json: json,
        );
      case HTTPStatusClientFailureAPIResult(
          :final statusCode,
          :final statusType,
          :final message,
          :final json,
          :final errorType,
        ):
        switch (errorType) {
          case ClientErrorsEnum.unauthorised:
            return UnauthorisedRepositoryResult(message: message);
          default:
            return OtherRepositoryResult(
              statusCode: statusCode,
              statusType: statusType,
              message: message,
              json: json,
            );
        }
      case FailureAPIResult(:final apiErrorType, :final message):
        switch (apiErrorType) {
          case ApiErrorType.noInternet:
            return InternetNotConnectedRepositoryResult();
          case ApiErrorType.lostInternetConnection:
            return InternetConnectionLostRepositoryResult();
          case ApiErrorType.timeout:
            return TimeOutRepositoryResult();
          default:
            return UnknownRepositoryResult(message: message);
        }
    }
  }
}
