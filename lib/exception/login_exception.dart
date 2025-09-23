class LoginException implements Exception {
  String errMessage() => "Password should not be 123";
  String toString() => "Password should not be 123";
}