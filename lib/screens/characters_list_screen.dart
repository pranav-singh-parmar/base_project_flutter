import 'package:flutter/material.dart';
import '../api_services/streams/character_stream_controller.dart';

class CharactersListScree extends StatefulWidget {
  const CharactersListScree({Key? key}) : super(key: key);

  @override
  State<CharactersListScree> createState() => _CharactersListScreeState();
}

class _CharactersListScreeState extends State<CharactersListScree> {
  final CharactersStreamController _countrySC = CharactersStreamController();

  @override
  void initState() {
    super.initState();
    _countrySC.getCharacters();
    _countrySC.getCharactersStream.listen((event) {
      debugPrint("data received in my_screen");
    });
  }

  @override
  void dispose() {
    _countrySC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(),
    );
  }
}
