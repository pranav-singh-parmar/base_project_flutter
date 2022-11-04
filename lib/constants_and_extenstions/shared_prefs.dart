import 'dart:convert';

import 'app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'extensions.dart';

class SharedPrefs {
  late SharedPreferences _sharedPrefs;

  SharedPrefs() {
    "initialise SharedPrefs".log();
    _initialiseSharePrefs();
  }

  void _initialiseSharePrefs() async {
    "initialise start".log();
    // if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
    // if (Platform.isIOS) SharedPreferencesIOS.registerWith();
    _sharedPrefs = await SharedPreferences.getInstance();
    "initialise completed".log();
  }

  void resetSharedPrefs() async {
    //final String fcmToken = getString(SharedPrefsKeys.fcmToken);
    await _sharedPrefs.clear();
    //setString(SharedPrefsKeys.fcmToken, fcmToken);
  }

  void setBool(String inKey, bool value) async =>
      await _sharedPrefs.setBool(inKey, value);

  bool getBool(String fromKey) => _sharedPrefs.getBool(fromKey) ?? false;

  void setInt(String inKey, int value) async =>
      await _sharedPrefs.setInt(inKey, value);

  int getInt(String fromKey) => _sharedPrefs.getInt(fromKey) ?? -1;

  void getDouble(String inKey, double value) async =>
      await _sharedPrefs.setDouble(inKey, value);

  double setDouble(String fromKey) => _sharedPrefs.getDouble(fromKey) ?? -1;

  void setString(String inKey, String value) async =>
      await _sharedPrefs.setString(inKey, value);

  String getString(String fromKey) =>
      _sharedPrefs.getString(fromKey)?.trim() ?? "";

  void setJson<T>(String inKey, Map<String, dynamic> value) =>
      setString(inKey, json.encode(value));

  Map<String, dynamic> getJson(String key) {
    try {
      return json.decode(_sharedPrefs.getString(key)?.trim() ?? "");
    } catch (exception) {
      "error in getJson function --> $exception".log();
    }
    return <String, dynamic>{};
  }

  // bool isUserLoggedIn() =>
  //     _sharedPrefs.getString(SharedPrefsKeys.loginResponse)?.isNotEmpty ??
  //     false;

  // LoginModel getUserData() =>
  //     LoginModel.fromJson(getJson(SharedPrefsKeys.loginResponse));
}
