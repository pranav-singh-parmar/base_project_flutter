import 'package:base_project_flutter/api_services/models/characters_response.dart';
import 'package:base_project_flutter/screens/widgets/CustomNetworkImage.dart';
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

  Future<void> _onRefresh() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: 10,
            itemBuilder: characterCell),
      ),
    );
  }

  Widget characterCell(BuildContext context, int index) {
    //final character =
    final screenDimensions = MediaQuery.of(context).size;
    return Row(
      children: [
        CustomNetworkImage(),
        Column(children: [
          Text("Name"),
          Text("Name"),
        ])
      ],
    );
  }
}
