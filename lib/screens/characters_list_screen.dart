import '../constants_and_extenstions/app_constants.dart';
import 'widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import '../api_services/streams/character_stream_controller.dart';

class CharactersListScreen extends StatefulWidget {
  const CharactersListScreen({Key? key}) : super(key: key);

  @override
  State<CharactersListScreen> createState() => _CharactersListScreenState();
}

class _CharactersListScreenState extends State<CharactersListScreen> {
  final CharactersStreamController _characterSC = CharactersStreamController();

  @override
  void initState() {
    super.initState();
    _characterSC.getCharacters(context);
  }

  @override
  void dispose() {
    _characterSC.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await _characterSC.getCharacters(context, clearList: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: StreamBuilder<ApiStatus>(
            stream: _characterSC.getCharactersStream,
            builder: (context, snapshot) {
              final characters = _characterSC.characters;
              if (snapshot.data == ApiStatus.isBeingHit && characters.isEmpty) {
                return const CircularProgressIndicator();
              } else {
                if (characters.isEmpty) {
                  return const Text("No data Available");
                }
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: characters.length,
                    itemBuilder: characterCell);
              }
            }),
      ),
    );
  }

  Widget characterCell(BuildContext context, int index) {
    //final character =
    final screenDimensions = MediaQuery.of(context).size;
    final character = _characterSC.characters[index];
    return Row(
      children: [
        CustomNetworkImage(
          imageURL: character.img,
          height: screenDimensions.width * 0.3,
          width: screenDimensions.width * 0.3,
        ),
        Column(children: [
          Text(character.name ?? ""),
          Text(character.portrayed ?? ""),
        ])
      ],
    );
  }
}
