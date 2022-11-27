import 'dart:async';

import 'stream_base.dart';
import '../../constants_and_extenstions/singleton.dart';
import 'dart:developer' show inspect;
import 'package:flutter/material.dart' show debugPrint;
import '../../constants_and_extenstions/app_constants.dart'
    show ApiEndPoints, ApiStatus, HttpMehod, ParameterEncoding;
import '../models/characters_response.dart';

class CharactersStreamController implements StreamBase {
  List<Character> characters = [];
  int _total = 0;
  int _currentLength = 0;

  bool get fetchedAllData => _total <= _currentLength;
    
  void paginateWithIndex(int index) {
      if (getCharactersStream.first != ApiStatus.isBeingHit && index == _currentLength - 1 && !fetchedAllData) {
          getCharacters(clearList: false);
      }
  }

  final StreamController<ApiStatus> _getCharactersSC =
      StreamController<ApiStatus>();

  Stream<ApiStatus> get getCharactersStream => _getCharactersSC.stream;

  Future<void> getCharacters({bool clearList = false}) async {
    final json = await Singleton.instance.apiServices.hitApi(
        httpMethod: HttpMehod.get,
        endPoint: ApiEndPoints.characters,
        parameterEncoding: ParameterEncoding.queryParameters,
        parameters: {
          "limit": 10,
        },
        whenInternotNotConnected: (() {
          getCharacters();
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
