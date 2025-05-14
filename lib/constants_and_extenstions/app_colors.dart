import 'package:flutter/material.dart';

class AppColors {
  //Shared Instance
  AppColors._sharedInstance() : super();
  static final AppColors _shared = AppColors._sharedInstance();
  factory AppColors() => _shared;

  final primary = const Color(0xFF552CFF);

  final blackTwo = const Color(0xFF181818);
  final blackThree = const Color(0xFF17191E);

  final whiteTwo = const Color(0xFFF2F2F2);

  final lighterGray = const Color(0xFFF7F7F7);
  final lightGray = const Color(0xFFECECEC);
  final gray = const Color(0xFF8B8B8B);
  final darkGray = const Color(0xFF595959);
  final darkerGrey = const Color(0xFF2E3034);
}
