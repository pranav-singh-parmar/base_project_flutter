class BaseRepository {
  String getErrorMessage(dynamic json) {
    if (json['message'] is String) {
      return json['message'];
    } else if (json['error'] is String) {
      return json['error'];
    } else if (json['error'] is List) {
      List<dynamic> errorMessages = json['error'];
      String errorMessage = errorMessages.join(', ');
      return errorMessage;
    } else {
      return "Server Error";
    }
  }
}
