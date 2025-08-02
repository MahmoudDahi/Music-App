class AppFailure {
  final String message;
  AppFailure([this.message = 'Sorry,an Unexpected error occured !!']);

  @override
  String toString() => 'AppFailure(message: $message)';
}
