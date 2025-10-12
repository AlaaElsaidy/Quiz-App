part of 'quiz_creation_cubit.dart';

@immutable
sealed class QuizCreationState {}

final class QuizCreationInitial extends QuizCreationState {}

final class QuizCreationLoading extends QuizCreationState {}

final class SaveQuizSuccess extends QuizCreationState {}

final class SaveQuizFailure extends QuizCreationState {
  final String message;

  SaveQuizFailure(this.message);
}

final class AddQuizSuccess extends QuizCreationState {}

final class AddQuizFailure extends QuizCreationState {
  final String message;

  AddQuizFailure(this.message);
}
