import 'dart:async';

import '../models/anime_list_response.dart';
import 'stream_base.dart';
import '../../constants_and_extenstions/singleton.dart';
import 'package:flutter/material.dart' show BuildContext;
import '../../constants_and_extenstions/app_constants.dart'
    show ApiEndPoints, ApiStatus, HttpMehod;

class AnimesStreamController implements StreamBase {
  ApiStatus _animeAS = ApiStatus.notHitOnce;
  List<AnimeModel?> animes = [];
  int _totalPage = 0;
  int _currentLength = 0;
  int _currentPage = 1;

  bool get fetchedAllData => _totalPage <= _currentPage;

  void paginateWithIndex(BuildContext context, int index) {
    if (_animeAS != ApiStatus.isBeingHit &&
        index == _currentLength - 1 &&
        !fetchedAllData) {
      getAnimes(context, clearList: false);
    }
  }

  final StreamController<ApiStatus> _getAnimesSC =
      StreamController<ApiStatus>();

  Stream<ApiStatus> get getAnimesStream => _getAnimesSC.stream;

  void _updateAnimeAS(ApiStatus apiStatus) {
    _animeAS = apiStatus;
    _getAnimesSC.sink.add(_animeAS);
  }

  Future<void> getAnimes(BuildContext context, {bool clearList = false}) async {
    if (clearList) {
      _currentPage = 1;
    }

    _updateAnimeAS(ApiStatus.isBeingHit);
    final uri = Singleton.instance.apiServices.getUri(
        endPoint: ApiEndPoints.anime,
        queryparameters: {
          "page": _currentPage,
          "size": "10",
          "search": "Dragon Ball Z"
        });
    final json = await Singleton.instance.apiServices
        .hitApi(context, HttpMehod.get, uri, extraHeaders: {
      "X-RapidAPI-Key": "2b975442demsh14dd8bb5a692b60p17c702jsnc458dbd221ae",
      "X-RapidAPI-Host": "anime-db.p.rapidapi.com"
    }, whenInternotNotConnected: (() {
      getAnimes(context, clearList: clearList);
    }));

    if (clearList) {
      animes.clear();
    }
    _currentPage++;

    if (json != null) {
      final animeResponse = AnimeListResponse.fromJson(json);
      _totalPage = animeResponse.meta?.totalPage ?? 0;
      animes.addAll(animeResponse.data ?? []);
      _currentLength = animes.length;
      _updateAnimeAS(ApiStatus.apiHit);
    } else {
      _updateAnimeAS(ApiStatus.apiHitWithError);
    }
  }

  @override
  void dispose() {
    _getAnimesSC.close();
  }
}
