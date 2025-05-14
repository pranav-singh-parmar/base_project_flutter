import 'package:fluttertoast/fluttertoast.dart';

import 'theme_controller.dart';

class FlutterToastManager {
  // Shared Instance
  FlutterToastManager._sharedInstance() : super();
  static final FlutterToastManager _shared =
      FlutterToastManager._sharedInstance();
  factory FlutterToastManager() => _shared;

  void showToast({
    required String withMessage,
  }) {
    Fluttertoast.showToast(
        msg: withMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: ThemeController().themeBasedWhiteColor,
        textColor: ThemeController().textColor3,
        fontSize: 16.0);
  }
}
