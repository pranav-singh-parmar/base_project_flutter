import 'dart:async';

import 'stream_base.dart';
import '../../constants_and_extenstions/singleton.dart';
import 'dart:developer' show inspect;
import 'package:flutter/material.dart' show debugPrint;
import '../../constants_and_extenstions/app_constants.dart'
    show ApiEndPoints, HttpMehod, ParameterEncoding;
import '../models/characters_response.dart';

class CharactersStreamController implements StreamBase {
  final StreamController<Character> _getCharactersSC =
      StreamController<Character>();

  Stream<Character> get getCharactersStream => _getCharactersSC.stream;

  void getCharacters() async {
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

    if (json != null) {
      //_getCharactersSC.sink.add(true);
    }
  }

  @override
  void dispose() {
    _getCharactersSC.close();
  }
}
