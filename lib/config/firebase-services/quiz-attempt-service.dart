import 'package:cloud_firestore/cloud_firestore.dart';

class QuizAttemptData {
  final int score;
  final int total;
  final int correct;
  final int wrong;

  QuizAttemptData({
    required this.score,
    required this.total,
    required this.correct,
    required this.wrong,
  });

  factory QuizAttemptData.fromDoc(DocumentSnapshot doc) {
    final d = (doc.data() as Map<String, dynamic>?) ?? {};
    return QuizAttemptData(
      score: (d['score'] ?? 0) as int,
      total: (d['total'] ?? 0) as int,
      correct: (d['correct'] ?? 0) as int,
      wrong: (d['wrong'] ?? 0) as int,
    );
  }
}

class QuizAttemptService {
  final _col = FirebaseFirestore.instance.collection('quiz_attempts');

  String _docId({required String quizId, required String userId}) =>
      '${quizId}_$userId';

  Future<QuizAttemptData?> fetchAttempt({
    required String quizId,
    required String userId,
  }) async {
    try {
      final doc = await _col.doc(_docId(quizId: quizId, userId: userId)).get();
      if (!doc.exists) return null;
      return QuizAttemptData.fromDoc(doc);
    } catch (_) {
      return null;
    }
  }

  Future<void> createAttempt({
    required String quizId,
    required String userId,
    required int score,
    required int total,
    required int correct,
    required int wrong,
    Map<String, String?>? answers,
    String? quizName,
  }) async {
    final ref = _col.doc(_docId(quizId: quizId, userId: userId));
    final existing = await ref.get();
    if (existing.exists) {
      throw Exception('Attempt already exists');
    }
    await ref.set({
      'quizId': quizId,
      'quizName': quizName,
      'userId': userId,
      'score': score,
      'total': total,
      'correct': correct,
      'wrong': wrong,
      'answers': answers ?? {},
      'submittedAt': FieldValue.serverTimestamp(),
    });
  }
}
