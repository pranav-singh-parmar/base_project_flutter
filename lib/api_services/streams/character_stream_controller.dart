import 'dart:async';
import 'stream_base.dart';
import '../../constants_and_extenstions/singleton.dart';
import 'package:flutter/material.dart' show BuildContext;
import '../../constants_and_extenstions/app_constants.dart'
    show ApiEndPoints, ApiStatus, HttpMehod;
import '../models/characters_response.dart';

class CharactersStreamController implements StreamBase {
  List<Character> characters = [];
  int _total = 0;
  int _currentLength = 0;

  bool get fetchedAllData => _total <= _currentLength;

  void paginateWithIndex(BuildContext context, int index) {
    if (getCharactersStream.first != ApiStatus.isBeingHit &&
        index == _currentLength - 1 &&
        !fetchedAllData) {
      getCharacters(context, clearList: false);
    }
  }

  final StreamController<ApiStatus> _getCharactersSC =
      StreamController<ApiStatus>();

  Stream<ApiStatus> get getCharactersStream => _getCharactersSC.stream;

  Future<void> getCharacters(BuildContext context,
      {bool clearList = false}) async {
    final uri = Singleton.instance.apiServices
        .getUri(endPoint: ApiEndPoints.anime, queryparameters: {"limit": 10});
    final json = await Singleton.instance.apiServices
        .hitApi(context, HttpMehod.get, uri, whenInternotNotConnected: (() {
      getCharacters(context, clearList: clearList);
    }));

    if (clearList) {
      characters.clear();
    }

    if (json != null) {
      _total = 30;
      final newCharacters = charactersFromDynamic(json);
      characters.addAll(newCharacters);
      _currentLength = characters.length;
      _getCharactersSC.sink.add(ApiStatus.apiHit);
    } else {
      _getCharactersSC.sink.add(ApiStatus.apiHitWithError);
    }
  }

  @override
  void dispose() {
    _getCharactersSC.close();
  }
}
