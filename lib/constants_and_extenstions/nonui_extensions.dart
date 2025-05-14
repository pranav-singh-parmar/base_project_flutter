import 'dart:developer' as devtools show log;

//https://arjun-mahar.medium.com/boost-your-debugging-experience-log-pretty-text-in-flutter-348d67e7c008#:~:text=Logging%20Red%20Text%3A%20The%20logError,set%20the%20color%20to%20red.
extension Log on Object? {
  void log() => devtools.log("App Name Logs: ${toString()}");
  void logWith({
    required Object error,
    required StackTrace? stack,
  }) {
    devtools.log("\x1B[31m${toString()}\x1B[0m", name: "ErrorTag");
    devtools.log("\x1B[31m$error\x1B[0m", name: "ErrorDetails");
    devtools.log("$stack", name: "Stack");

    // final text = "${toString()}\nError: $error\nStack: $stack";
    // devtools.log(
    //   "\x1B[31m${toString()}\x1B[0m", // The message to log
    //   name: "Error",
    //   level: 500, // Level.SEVERE (high severity)
    //   error: error, // Error object (optional)
    //   stackTrace: stack, // Stack trace (optional));
    // );
  }
}

extension Merge<K, V> on Map<K, V> {
  Map<String, String> toMapStringString() {
    Map<String, String> map = <String, String>{};
    for (final entry in entries) {
      map[entry.key.toString()] = entry.value.toString();
    }
    return map;
  }
}

extension GetFileExtension on String {
  String get getFileExtension => split('.').last;
}

extension RemoveLastCharacter on String {
  String removeLastChar() {
    return isNotEmpty ? substring(0, length - 1) : this;
  }
}

extension Validations on String {
  bool get isValidEmail {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(this);
  }

  bool get isValidPassword {
    return length > 5;
  }
}
