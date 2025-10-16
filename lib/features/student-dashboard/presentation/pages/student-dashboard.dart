import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzo/config/firebase-services/authentication.dart';
import 'package:quizzo/config/router/routes.dart';
import 'package:quizzo/config/screen_sizer/size_extension.dart';
import 'package:quizzo/config/shared/widgets/loading.dart';
import 'package:quizzo/features/student-dashboard/data/repositories/available-repo.dart';
import 'package:quizzo/features/student-dashboard/presentation/cubit/availabe_quizes_cubit.dart';
import 'package:quizzo/features/student-quiz/presentation/pages/student-quiz.dart';

import '../../../../config/firebase-services/quiz-attempt-service.dart';
import '../../../../config/utilis/app_colors.dart';
import '../../../result/result-screen.dart';
import '../widgets/available-quiz-item.dart';

class StudentDashboard extends StatelessWidget {
  StudentDashboard({super.key});

  final _attemptService = QuizAttemptService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          "Available Quiz",
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: context.sp(28),
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) =>
        AvailabeQuizesCubit(AvailableQuizesRepo())
          ..getTotalQuizes(),
        child: BlocBuilder<AvailabeQuizesCubit, AvailabeQuizesState>(
          builder: (context, state) {
            if (state is AvailabeQuizesLoading) {
              return LoadingPage();
            } else if (state is AvailabeQuizesFailure) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                          Icons.error_outline, color: Colors.red, size: 40),
                      SizedBox(height: context.h(12)),
                      Text(
                        state.errorMessage ?? 'Failed to load quizzes.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      SizedBox(height: context.h(16)),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AvailabeQuizesCubit>().getTotalQuizes();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is AvailabeQuizesSuccess) {
              final data = state.totalQuiz;

              if (data.isEmpty) {
                return Center(
                  child: Text(
                    'No quizzes available right now.',
                    style: TextStyle(
                        fontSize: context.sp(18), color: Colors.black54),
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(32.5),
                  vertical: context.h(50),
                ),
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) =>
                      AvailableQuizItem(
                        questionNum: data[index].quizes.length,
                        quizName: data[index].quizName,
                        onClick: () async {
                          final uid = FirebaseAuth.instance.currentUser?.uid;
                          if (uid == null) return;

                          final String quizId = (data[index].quizName)
                              .toString()
                              .replaceAll(RegExp(r'[/#?]'), '_');

                          final attempt = await _attemptService.fetchAttempt(
                            quizId: quizId,
                            userId: uid,
                          );

                          if (attempt != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StudentQuiz(
                                    quizId: quizId,
                                    quizName: data[index].quizName,
                                    quizModel: data[index].quizes,
                                  ),
                            ),
                          );
                        },
                      ),
                ),
              );
            } else {
              return LoadingPage();
            }
          },
        ),
      ),
    );
  }
}