import 'package:dartz/dartz.dart';
import 'package:quizzo/config/firebase-services/failure.dart';
import 'package:quizzo/config/firebase-services/firebase-firestore.dart';
import 'package:quizzo/features/quiz-creation/data/models/quiz-model.dart';

class QuizCreationRepo {
  Future<Either<Failure, void>> addQuiz(TotalQuiz totalQuiz) async {
    try {
      await FirebaseFireStrore.addQuiz(totalQuiz);
      return const Right(null);
    } catch (error) {
      return Left(Failure(error.toString()));
    }
  }
}
