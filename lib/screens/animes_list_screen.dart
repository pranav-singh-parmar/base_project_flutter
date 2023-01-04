import '../api_services/streams/anime_stream_controller.dart';
import '../constants_and_extenstions/app_constants.dart';
import 'widgets/custom_network_image.dart';
import 'package:flutter/material.dart';

class AnimesListScreen extends StatefulWidget {
  const AnimesListScreen({Key? key}) : super(key: key);

  @override
  State<AnimesListScreen> createState() => _AnimesListScreenState();
}

class _AnimesListScreenState extends State<AnimesListScreen> {
  final AnimesStreamController _animesSC = AnimesStreamController();

  @override
  void initState() {
    super.initState();
    _animesSC.getAnimes(context);
  }

  @override
  void dispose() {
    _animesSC.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await _animesSC.getAnimes(context, clearList: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: StreamBuilder<ApiStatus>(
            stream: _animesSC.getAnimesStream,
            builder: (context, snapshot) {
              final characters = _animesSC.animes;
              if (snapshot.data == ApiStatus.isBeingHit && characters.isEmpty) {
                return const CircularProgressIndicator();
              } else {
                if (characters.isEmpty) {
                  return const Text("No data Available");
                }
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _animesSC.fetchedAllData
                        ? _animesSC.animes.length
                        : _animesSC.animes.length + 1,
                    itemBuilder: (context, index) {
                      return index >= _animesSC.animes.length
                          ? const Center(child: CircularProgressIndicator())
                          : _animeCell(
                              index,
                            );
                    });
              }
            }),
      ),
    );
  }

  Widget _animeCell(int index) {
    //final character =
    final screenDimensions = MediaQuery.of(context).size;
    final anime = _animesSC.animes[index];
    return Row(
      children: [
        CustomNetworkImage(
          imageURL: anime?.image,
          height: screenDimensions.width * 0.3,
          width: screenDimensions.width * 0.3,
        ),
        Expanded(
            child: Column(children: [
          Text(anime?.title ?? ""),
          Text(anime?.id ?? ""),
        ]))
      ],
    );
  }
}
