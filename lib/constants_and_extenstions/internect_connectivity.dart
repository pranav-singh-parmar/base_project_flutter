import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'nonui_extensions.dart';

class InternetConnectivity {
  //Shared Instance
  InternetConnectivity._sharedInstance() : super() {
    _checkForInternetConnection();
  }
  static final InternetConnectivity _shared =
      InternetConnectivity._sharedInstance();
  factory InternetConnectivity() => _shared;

  //Streams
  final StreamController<bool> _checkIsInternetConnected =
      StreamController<bool>();
  Stream<bool> get checkInternetConnectionStream =>
      _checkIsInternetConnected.stream;

  //Stream Subscription
  StreamSubscription? subscription;

  //Properties
  bool isInternetConnected = false;

  void _checkForInternetConnection() async {
    subscription =
        InternetConnectionChecker.instance.onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
        case InternetConnectionStatus.slow:
          isInternetConnected = true;
          break;
        case InternetConnectionStatus.disconnected:
          isInternetConnected = false;
          break;
      }
      ("Last Data", status, _checkIsInternetConnected).log();
      _checkIsInternetConnected.sink.add(isInternetConnected);
    });
  }

  void dispose() {
    _checkIsInternetConnected.close();
    subscription?.cancel();
  }
}
