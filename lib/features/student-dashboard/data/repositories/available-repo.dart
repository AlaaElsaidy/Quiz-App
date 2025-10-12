import 'package:dartz/dartz.dart';
import 'package:quizzo/config/firebase-services/failure.dart';
import 'package:quizzo/config/firebase-services/firebase-firestore.dart';
import 'package:quizzo/features/quiz-creation/data/models/quiz-model.dart';

class AvailableQuizesRepo {
  Future<Either<Failure, List<TotalQuiz>>> getTotalQuizes() async {
    try {
      var data = await FirebaseFireStrore.getTotalQuizes();
      return right(data);
    } catch (error) {
      return left(Failure(error.toString()));
    }
  }
}
