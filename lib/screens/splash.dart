import '../constants_and_extenstions/theme_controller.dart';
import 'animes_list_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  final _themeController = ThemeController();

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      navigateUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Splash Screen",
          style: _themeController.bitterFont(
            fontSize: FontSize.body,
          ),
        ),
      ),
    );
  }

  void navigateUser() async {
    _timer.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AnimesListScreen()),
    );
  }
}
