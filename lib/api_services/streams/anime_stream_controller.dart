import 'dart:async';

import '../../constants_and_extenstions/app_constants.dart';
import '../../constants_and_extenstions/flutter_toast_manager.dart';
import '../../constants_and_extenstions/nonui_extensions.dart';
import '../models/anime_list_response.dart';
import '../repositories/anime_repository.dart';
import '../repositories/repository_result.dart';
import 'stream_base.dart';

class AnimesStreamController implements StreamBase {
  ApiStatus _animeAS = ApiStatus.notHitOnce;
  List<AnimeModel?> animes = [];
  int _totalPage = 0;
  int _currentLength = 0;
  int _currentPage = 1;

  bool get fetchedAllData => _totalPage <= _currentPage;

  void paginateWithIndex(int index) {
    if (_animeAS != ApiStatus.isBeingHit &&
        index == _currentLength - 1 &&
        !fetchedAllData) {
      getAnimes(clearList: false);
    }
  }

  final StreamController<ApiStatus> _getAnimesSC =
      StreamController<ApiStatus>();

  Stream<ApiStatus> get getAnimesStream => _getAnimesSC.stream;

  void _updateAnimeAS(ApiStatus apiStatus) {
    _animeAS = apiStatus;
    _getAnimesSC.sink.add(_animeAS);
  }

  Future<void> getAnimes({bool clearList = false}) async {
    if (clearList) {
      _currentPage = 1;
    }

    _updateAnimeAS(ApiStatus.isBeingHit);

    final repository = AnimeRepository();
    final result = await repository.getAnimeList(
      search: "Dragon Ball Z",
      page: _currentPage,
    );

    switch (result) {
      case SuccessRepositoryResult<AnimeListResponse>(:final data):
        "Success".log();

        if (clearList) {
          animes.clear();
        }
        _currentPage++;

        _totalPage = data.meta?.totalPage ?? 0;
        animes.addAll(data.data ?? []);
        _currentLength = animes.length;
        _updateAnimeAS(ApiStatus.apiHit);

        break;
      case InternetNotConnectedRepositoryResult():
        "InternetNotConnectedRepositoryResult".log();
        Future.delayed(
          const Duration(seconds: 2),
          () => getAnimes(clearList: clearList),
        );

        break;
      case UnauthorisedRepositoryResult():
        "UnauthorisedRepositoryResult".log();
        _updateAnimeAS(ApiStatus.apiHitWithError);
        break;
      case ValidationFailedRepositoryResult(:final message):
        "ValidationFailedRepositoryResult".log();
        FlutterToastManager().showToast(withMessage: message);
        _updateAnimeAS(ApiStatus.apiHitWithError);
        break;
      case CustomRepositoryResult<AnimeRespositoryResultEnum>(:final reason):
        "$reason".log();
        _updateAnimeAS(ApiStatus.apiHitWithError);
        FlutterToastManager().showToast(withMessage: "$reason");
      default:
        //getAnimes(context, clearList: clearList);
        _updateAnimeAS(ApiStatus.apiHitWithError);
        break;
    }
  }

  @override
  void dispose() {
    _getAnimesSC.close();
  }
}
