import 'package:base_project_flutter/screens/splash.dart';
import 'package:flutter/material.dart';
import '../constants_and_extenstions/singleton.dart';

void main() {
  runApp(const MyApp());
  Singleton.instance;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Base Project Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}