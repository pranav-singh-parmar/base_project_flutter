import 'dart:convert';

List<Character> charactersFromJson(String str) =>
    List<Character>.from(
        json.decode(str).map((x) => Character.fromJson(x)));

List<Character> charactersFromDynamic(dynamic map) =>
    List<Character>.from(
        map.map((x) => Character.fromJson(x)));

String charactersToJson(List<Character> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Character {
  Character({
    this.charId,
    this.name,
    this.birthday,
    this.occupation,
    this.img,
    this.status,
    this.nickname,
    this.appearance,
    this.portrayed,
    this.category,
    this.betterCallSaulAppearance,
  });

  final int? charId;
  final String? name;
  final String? birthday;
  final List<String>? occupation;
  final String? img;
  final String? status;
  final String? nickname;
  final List<int>? appearance;
  final String? portrayed;
  final String? category;
  final List<int>? betterCallSaulAppearance;

  factory Character.fromJson(Map<String, dynamic> json) =>
      Character(
        charId: json["char_id"],
        name: json["name"],
        birthday: json["birthday"],
        occupation: json["occupation"] == null
            ? null
            : List<String>.from(json["occupation"].map((x) => x)),
        img: json["img"],
        status: json["status"],
        nickname: json["nickname"],
        appearance: json["appearance"] == null
            ? null
            : List<int>.from(json["appearance"].map((x) => x)),
        portrayed: json["portrayed"],
        category: json["category"],
        betterCallSaulAppearance: json["better_call_saul_appearance"] == null
            ? null
            : List<int>.from(json["better_call_saul_appearance"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "char_id": charId,
        "name": name,
        "birthday": birthday,
        "occupation": occupation == null
            ? null
            : List<dynamic>.from((occupation ?? []).map((x) => x)),
        "img": img,
        "status": status,
        "nickname": nickname,
        "appearance": appearance == null
            ? null
            : List<dynamic>.from((appearance ?? []).map((x) => x)),
        "portrayed": portrayed,
        "category": category,
        "better_call_saul_appearance": betterCallSaulAppearance == null
            ? null
            : List<dynamic>.from(
                (betterCallSaulAppearance ?? []).map((x) => x)),
      };
}
