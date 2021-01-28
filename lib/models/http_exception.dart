class HttpException implements Exception {
  final String message;
  @override
  HttpException(this.message);
  String toString() {
    return message;
  }
}
