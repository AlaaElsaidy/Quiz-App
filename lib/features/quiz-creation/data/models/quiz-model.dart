class QuizModel {
  int id;
  String quiz;
  List<String> answers;
  String correctAnswer;

  QuizModel({
    required this.id,
    required this.quiz,
    required this.answers,
    required this.correctAnswer,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json["id"],
      quiz: json["quiz"],
      answers: List<String>.from(json["answers"] ?? []),
      correctAnswer: json["correctAnswer"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "quiz": quiz,
      "answers": answers,
      "correctAnswer": correctAnswer,
    };
  }
}

class TotalQuiz {
  static String collectionName = "Quizes";
  String quizName;
  List<QuizModel> quizes;

  TotalQuiz({required this.quizName, required this.quizes});

  factory TotalQuiz.fromJson(Map<String, dynamic> json) {
    return TotalQuiz(
      quizName: json["quizName"],
      quizes: (json["quizes"] as List)
          .map((e) => QuizModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "quizName": quizName,
      "quizes": quizes.map((e) => e.toJson()).toList(),
    };
  }
}
