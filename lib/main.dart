import 'package:flutter/material.dart';

import 'constants_and_extenstions/shared_prefs.dart';
import 'constants_and_extenstions/theme_controller.dart';
import 'screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final List<Future<dynamic>> list = [
    SharedPrefs().initialiseSharePrefs(),
    //Firebase.initializeApp(),
  ];
  await Future.wait(list);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Base Project Flutter',
      theme: ThemeController().getThemeData(),
      darkTheme: ThemeController().getThemeData(),
      home: const SplashScreen(),
    );
  }
}
