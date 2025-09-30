class LoginException implements Exception {
  String errMessage() => "Password should not be 123";
  @override
  String toString() => "Password should not be 123";
}

class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}