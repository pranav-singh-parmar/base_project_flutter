//https://rapidapi.com/SAdrian/api/moviesdatabase/
//https://rapidapi.com/brian.rofiq/api/anime-db/

import 'dart:convert';

AnimeListResponse animeListResponseFromJson(String str) =>
    AnimeListResponse.fromJson(json.decode(str));

String animeListResponseToJson(AnimeListResponse data) =>
    json.encode(data.toJson());

class AnimeListResponse {
  AnimeListResponse({
    this.data,
    this.meta,
  });

  final List<AnimeModel?>? data;
  final Meta? meta;

  factory AnimeListResponse.fromJson(Map<String, dynamic> json) =>
      AnimeListResponse(
        data: json["data"] == null
            ? null
            : List<AnimeModel>.from(
                json["data"].map((x) => AnimeModel.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from((data ?? []).map((x) => x?.toJson())),
        "meta": meta?.toJson(),
      };
}

class AnimeModel {
  AnimeModel({
    this.id,
    this.title,
    this.alternativeTitles,
    this.ranking,
    this.genres,
    this.episodes,
    this.hasEpisode,
    this.hasRanking,
    this.image,
    this.link,
    this.status,
    this.synopsis,
    this.thumb,
    this.type,
  });

  final String? id;
  final String? title;
  final List<String?>? alternativeTitles;
  final int? ranking;
  final List<String?>? genres;
  final int? episodes;
  final bool? hasEpisode;
  final bool? hasRanking;
  final String? image;
  final String? link;
  final String? status;
  final String? synopsis;
  final String? thumb;
  final String? type;

  factory AnimeModel.fromJson(Map<String, dynamic> json) => AnimeModel(
        id: json["_id"],
        title: json["title"],
        alternativeTitles: json["alternativeTitles"] == null
            ? null
            : List<String>.from(json["alternativeTitles"].map((x) => x)),
        ranking: json["ranking"],
        genres: json["genres"] == null
            ? null
            : List<String>.from(json["genres"].map((x) => x)),
        episodes: json["episodes"],
        hasEpisode: json["hasEpisode"],
        hasRanking: json["hasRanking"],
        image: json["image"],
        link: json["link"],
        status: json["status"],
        synopsis: json["synopsis"],
        thumb: json["thumb"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "alternativeTitles": alternativeTitles == null
            ? null
            : List<String>.from((alternativeTitles ?? []).map((x) => x)),
        "ranking": ranking,
        "genres": genres == null
            ? null
            : List<dynamic>.from((genres ?? []).map((x) => x)),
        "episodes": episodes,
        "hasEpisode": hasEpisode,
        "hasRanking": hasRanking,
        "image": image,
        "link": link,
        "status": status,
        "synopsis": synopsis,
        "thumb": thumb,
        "type": type,
      };
}

class Meta {
  Meta({
    this.page,
    this.size,
    this.totalData,
    this.totalPage,
  });

  final int? page;
  final int? size;
  final int? totalData;
  final int? totalPage;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        page: json["page"],
        size: json["size"],
        totalData: json["totalData"],
        totalPage: json["totalPage"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "size": size,
        "totalData": totalData,
        "totalPage": totalPage,
      };
}
