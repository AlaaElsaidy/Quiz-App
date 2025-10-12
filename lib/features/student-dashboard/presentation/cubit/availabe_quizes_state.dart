part of 'availabe_quizes_cubit.dart';

@immutable
sealed class AvailabeQuizesState {}

final class AvailabeQuizesInitial extends AvailabeQuizesState {}

final class AvailabeQuizesLoading extends AvailabeQuizesState {}

final class AvailabeQuizesSuccess extends AvailabeQuizesState {
  List<TotalQuiz> totalQuiz;

  AvailabeQuizesSuccess(this.totalQuiz);
}

final class AvailabeQuizesFailure extends AvailabeQuizesState {
  String errorMessage;

  AvailabeQuizesFailure(this.errorMessage);
}
