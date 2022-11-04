import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
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