enum QuestionType { text, multipleChoice, trueFalse }

extension QuestionTypeX on QuestionType {
  String get label {
    switch (this) {
      case QuestionType.text:
        return 'Text';
      case QuestionType.multipleChoice:
        return 'Multiple Choice';
      case QuestionType.trueFalse:
        return 'True/False';
    }
  }
}
