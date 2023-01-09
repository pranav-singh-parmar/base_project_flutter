import 'package:base_project_flutter/constants_and_extenstions/app_strings.dart';

import 'widgets/custom_app_bar.dart';
import '../api_services/streams/anime_stream_controller.dart';
import '../constants_and_extenstions/app_constants.dart';
import 'widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import '../constants_and_extenstions/extensions.dart';

class AnimesListScreen extends StatefulWidget {
  const AnimesListScreen({Key? key}) : super(key: key);

  @override
  State<AnimesListScreen> createState() => _AnimesListScreenState();
}

class _AnimesListScreenState extends State<AnimesListScreen> {
  final ScrollController _scrollController = ScrollController();
  final AnimesStreamController _animesSC = AnimesStreamController();

  @override
  void initState() {
    super.initState();
    _animesSC.getAnimes(context);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _animesSC.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await _animesSC.getAnimes(context, clearList: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.anime),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: StreamBuilder<ApiStatus>(
            stream: _animesSC.getAnimesStream,
            builder: (context, snapshot) {
              final animes = _animesSC.animes;
              if (snapshot.data == ApiStatus.isBeingHit && animes.isEmpty) {
                return const CircularProgressIndicator();
              } else {
                if (animes.isEmpty) {
                  return const Text("No data Available");
                }
                return ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
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
    const double padding = 8;
    return Padding(
      padding: index == 0
          ? const EdgeInsets.only(
              top: padding * 2, left: padding, right: padding, bottom: padding)
          : const EdgeInsets.all(padding),
      child: Row(
        children: [
          CustomNetworkImage(
            isCircle: true,
            imageURL: anime?.image,
            height: screenDimensions.width * 0.3,
            width: screenDimensions.width * 0.3,
          ),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: padding),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          anime?.title ?? "",
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          anime?.type ?? "",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ])))
        ],
      ),
    );
  }

  void _scrollListener() {
    //final heightToStartPagiation = (_scrollController.position.maxScrollExtent - MediaQuery.of(context).size.height * .1);
    //if (_scrollController.position.pixels >= heightToStartPagiation) {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _animesSC.paginateWithIndex(context, _animesSC.animes.length - 1);
    }
  }
}
