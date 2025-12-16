abstract class AiDjState {}

class AiDjInitial extends AiDjState {}

class AiDjLoading extends AiDjState {}

class AiDjLoaded extends AiDjState {
  final List<String> songs;
  AiDjLoaded(this.songs);
}

class AiDjError extends AiDjState {
  final String message;
  AiDjError(this.message);
}
