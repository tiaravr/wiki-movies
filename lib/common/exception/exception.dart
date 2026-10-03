class MovieException implements Exception {
  final String errorMessage;

  MovieException(this.errorMessage);
}

class TimeOutException extends MovieException {
  TimeOutException(super.errorMessage);
}

class UnknownException extends MovieException {
  UnknownException(super.errorMessage);
}
