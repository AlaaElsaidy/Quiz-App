import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:quizzo/features/quiz-creation/data/models/quiz-model.dart';
import 'package:quizzo/features/quiz-creation/data/repositories/quiz-creation-repo.dart';

part 'quiz_creation_state.dart';

class QuizCreationCubit extends Cubit<QuizCreationState> {
  QuizCreationRepo quizCreationRepo;

  QuizCreationCubit({required this.quizCreationRepo})
    : super(QuizCreationInitial());

  Future<void> saveQUiz({required TotalQuiz totalQuiz}) async {
    emit(QuizCreationLoading());
    var result = await quizCreationRepo.addQuiz(totalQuiz);
    result.fold(
      (l) => emit(SaveQuizFailure(l.errorMessage!)),
      (r) => emit(SaveQuizSuccess()),
    );
  }

  void addQuestion(List<Map<String, TextEditingController>> controllers) {
    if (controllers.length > 9) {
      emit(AddQuizFailure("You can only add up to 10 questions."));
      return;
    }
    controllers.add({
      "question": TextEditingController(),
      "option1": TextEditingController(),
      "option2": TextEditingController(),
      "option3": TextEditingController(),
      "option4": TextEditingController(),
      "correct": TextEditingController(),
    });
    emit(AddQuizSuccess());
  }
}
