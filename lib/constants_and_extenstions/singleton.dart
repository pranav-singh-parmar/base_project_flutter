import '../api_services/api_services.dart';
import 'general_functions.dart';
import 'shared_prefs.dart';
import 'internect_connectivity.dart';

class Singleton {
  //https://stackoverflow.com/questions/12649573/how-do-you-build-a-singleton-in-dart

  // make constructor private, so that is is initialized once
  Singleton._privateConstructor();
  static final Singleton _instance = Singleton._privateConstructor();
  static Singleton get instance => _instance;
  // factory get instance() => _instance;

  // create instances of repeatedly used classes
  final ApiServices apiServices = ApiServices();

  final SharedPrefs sharedPrefs = SharedPrefs();

  final InternetConnectivity internetConnectivity = InternetConnectivity();

  final GeneralFunctions generalFunctions = GeneralFunctions();
}