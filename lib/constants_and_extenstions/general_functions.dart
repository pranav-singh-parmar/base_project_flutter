import 'package:fluttertoast/fluttertoast.dart';

class GeneralFunctions {
  T? cast<T>(x) => x is T ? x : null;

  void showToast(String message) {
    Fluttertoast.showToast(msg: message);
  }
}