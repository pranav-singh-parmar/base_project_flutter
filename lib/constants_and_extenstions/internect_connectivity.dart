import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetConnectivity {
  final StreamController<bool> _checkIsInternetConnected =
      StreamController<bool>();
  Stream<bool> get checkInternetConnectionStream =>
      _checkIsInternetConnected.stream;

  StreamSubscription? subcription;

  bool isInternetConnected = false;

  InternetConnectivity() {
    _checkForInternetConnection();
  }

  void _checkForInternetConnection() async {
    await isConnectedToInternet();
    if (!isInternetConnected) {
      subcription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        if (result != ConnectivityResult.none) {
          if (await isConnectedToInternet() == true) {
            subcription?.cancel();
            _checkIsInternetConnected.sink.add(isInternetConnected);
          }
        }
      });
    }
    _checkIsInternetConnected.sink.add(isInternetConnected);
  }

  Future<bool> isConnectedToInternet() async {
    bool result =
        await InternetConnectionChecker.createInstance().hasConnection;
    if (result == true) {
      isInternetConnected = true;
    } else {
      // print('No internet :( Reason:');
      // print(InternetConnectionChecker().las);
      isInternetConnected = false;
    }
    return isInternetConnected;
  }

  void dispose() {
    _checkIsInternetConnected.close();
  }
}
