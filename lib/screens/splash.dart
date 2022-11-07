import 'package:flutter/material.dart';
import 'dart:async';
import 'characters_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: 3), () {
      navigateUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text("Splash Screen")
    ));
  }

  void navigateUser() async {
    timer.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CharactersListScree()),
    );
  }
}
