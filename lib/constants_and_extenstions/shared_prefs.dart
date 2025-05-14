import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'app_constants.dart';
import 'nonui_extensions.dart';

class SharedPrefs {
  //Shared Instance
  SharedPrefs._sharedInstance() : super();
  static final SharedPrefs _shared = SharedPrefs._sharedInstance();
  factory SharedPrefs() => _shared;

  late SharedPreferences _sharedPrefs;

  Future<void> initialiseSharePrefs() async {
    // if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
    // if (Platform.isIOS) SharedPreferencesIOS.registerWith();
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  void resetSharedPrefs() async {
    //final String fcmToken = getString(SharedPrefsKeys.fcmToken);
    await _sharedPrefs.clear();
    //setString(SharedPrefsKeys.fcmToken, fcmToken);
  }

  void setBool({
    required bool value,
    required SharedPrefsKeys inKey,
  }) async =>
      await _sharedPrefs.setBool(inKey.value, value);

  bool? getBool({
    required SharedPrefsKeys fromKey,
  }) =>
      _sharedPrefs.getBool(fromKey.value);

  void setInt({
    required int value,
    required SharedPrefsKeys inKey,
  }) async =>
      await _sharedPrefs.setInt(inKey.value, value);

  int? getInt({
    required SharedPrefsKeys fromKey,
  }) =>
      _sharedPrefs.getInt(fromKey.value);

  void setDouble({
    required double value,
    required SharedPrefsKeys inKey,
  }) async =>
      await _sharedPrefs.setDouble(inKey.value, value);

  double? getDouble({
    required SharedPrefsKeys fromKey,
  }) =>
      _sharedPrefs.getDouble(fromKey.value);

  void setString({
    required String value,
    required SharedPrefsKeys inKey,
  }) async =>
      await _sharedPrefs.setString(inKey.value, value);

  String? getString({
    required SharedPrefsKeys fromKey,
  }) =>
      _sharedPrefs.getString(fromKey.value)?.trim();

  Future<bool> delete({
    required SharedPrefsKeys fromKey,
  }) =>
      _sharedPrefs.remove(fromKey.value);

  void setJSON({
    required Map<String, dynamic> value,
    required SharedPrefsKeys inKey,
  }) async =>
      setString(
        value: json.encode(value),
        inKey: inKey,
      );

  Map<String, dynamic>? getJSON({
    required SharedPrefsKeys fromKey,
  }) {
    final jsonString = _sharedPrefs.getString(fromKey.value)?.trim() ?? "";
    if (jsonString.isNotEmpty) {
      try {
        return json.decode(jsonString);
      } catch (exception) {
        "error in getJson function --> $exception".log();
      }
    }
    return null;
  }

  // bool isUserLoggedIn() =>
  //     _sharedPrefs.getString(SharedPrefsKeys.loginResponse)?.isNotEmpty ??
  //     false;

  // LoginModel getUserData() =>
  //     LoginModel.fromJson(getJson(SharedPrefsKeys.loginResponse));
}
