import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzo/config/firebase-services/authentication.dart';
import 'package:quizzo/config/router/routes.dart';
import 'package:quizzo/config/screen_sizer/size_extension.dart';
import 'package:quizzo/config/shared/widgets/loading.dart';
import 'package:quizzo/config/utilis/app_colors.dart';
import 'package:quizzo/features/quiz-creation/data/models/quiz-model.dart';
import 'package:quizzo/features/result/result-screen.dart';

import '../../../../config/firebase-services/quiz-attempt-service.dart';
import '../../../../config/shared/widgets/custom-button.dart';
import '../widgets/student-quiz-item.dart';

class StudentQuiz extends StatefulWidget {
  final List<QuizModel> quizModel;
  final String quizName;
  final String quizId;

  StudentQuiz({
    super.key,
    required this.quizModel,
    required this.quizName,
    required this.quizId,
  });

  @override
  State<StudentQuiz> createState() => _StudentQuizState();
}

class _StudentQuizState extends State<StudentQuiz> {
  final Map<int, String?> answers = {};
  final _attemptService = QuizAttemptService();
  bool _loadingCheck = true;

  String _normalize(String s) => s.trim().toLowerCase();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        setState(() => _loadingCheck = false);
        return;
      }

      try {
        final attempt = await _attemptService.fetchAttempt(
          quizId: widget.quizId,
          userId: uid,
        );

        if (!mounted) return;

        if (attempt != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ResultScreen(
                    score: attempt.score,
                    total: attempt.total,
                    correct: attempt.correct,
                    wrong: attempt.wrong,
                  ),
            ),
          );
          return;
        }
      } catch (_) {} finally {
        if (mounted) setState(() => _loadingCheck = false);
      }
    });
  }

  void _onAnswerSelected(int index, String value) {
    setState(() {
      answers[index] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingCheck) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text(
            widget.quizName,
            style: TextStyle(color: Colors.white, fontSize: context.sp(28)),
          ),
        ),
        body: const LoadingPage(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          highlightColor: Colors.transparent,
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuthentication.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                    (route) => false,
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          widget.quizName,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: context.sp(28),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(32.5),
            vertical: context.h(50),
          ),
          child: Column(
            children: [
              ...List.generate(
                widget.quizModel.length,
                    (index) {
                  final q = widget.quizModel[index];
                  return StudentQuizItem(
                    key: ValueKey('q_$index'),
                    questionNumber: (q.id) + 1,
                    question: q.quiz,
                    options: q.answers,
                    selectedAnswer: answers[index],
                    onAnswerSelected: (value) =>
                        _onAnswerSelected(index, value),
                  );
                },
              ),
              SizedBox(height: context.h(20)),
              CustomButton(
                onClick: () async {
                  int right = 0;
                  int wrong = 0;

                  for (int i = 0; i < widget.quizModel.length; i++) {
                    final q = widget.quizModel[i];
                    final userAns = answers[i];
                    final correct = q.correctAnswer;

                    if (userAns == null || userAns.isEmpty) {
                      wrong++;
                      continue;
                    }

                    if (q.answers.isEmpty) {
                      if (_normalize(userAns) == _normalize(correct)) {
                        right++;
                      } else {
                        wrong++;
                      }
                    } else {
                      if (_normalize(userAns) == _normalize(correct)) {
                        right++;
                      } else {
                        wrong++;
                      }
                    }
                  }

                  try {
                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    if (uid == null) return;

                    final answersToSave = answers.map(
                          (k, v) => MapEntry(k.toString(), v),
                    );

                    await _attemptService.createAttempt(
                      quizId: widget.quizId,
                      userId: uid,
                      score: right,
                      total: widget.quizModel.length,
                      correct: right,
                      wrong: wrong,
                      answers: answersToSave,
                      quizName: widget.quizName,
                    );

                    if (!mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ResultScreen(
                              score: right,
                              total: widget.quizModel.length,
                              correct: right,
                              wrong: wrong,
                            ),
                      ),
                          (route) => false,
                    );
                  } catch (e) {
                    if (!mounted) return;
                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    if (uid != null) {
                      final attempt = await _attemptService.fetchAttempt(
                        quizId: widget.quizId,
                        userId: uid,
                      );
                      if (attempt != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ResultScreen(
                                  score: attempt.score,
                                  total: attempt.total,
                                  correct: attempt.correct,
                                  wrong: attempt.wrong,
                                ),
                          ),
                        );
                        return;
                      }
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Unexpected error.')),
                    );
                    Navigator.pop(context);
                  }
                },
                text: "Submit",
              ),
            ],
          ),
        ),
      ),
    );
  }
}