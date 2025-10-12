import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzo/config/firebase-services/authentication.dart';
import 'package:quizzo/config/router/routes.dart';
import 'package:quizzo/config/screen_sizer/size_extension.dart';
import 'package:quizzo/config/shared/widgets/loading.dart';
import 'package:quizzo/features/student-dashboard/data/repositories/available-repo.dart';
import 'package:quizzo/features/student-dashboard/presentation/cubit/availabe_quizes_cubit.dart';
import 'package:quizzo/features/student-quiz/presentation/pages/student-quiz.dart';

import '../../../../config/utilis/app_colors.dart';
import '../widgets/available-quiz-item.dart';

class StudentDashboard extends StatelessWidget {
  StudentDashboard({super.key});

  AvailabeQuizesCubit availabeQuizesCubit = AvailabeQuizesCubit(
    AvailableQuizesRepo(),
  );

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
            icon: Icon(Icons.logout, color: Colors.white),
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
        create: (context) => availabeQuizesCubit..getTotalQuizes(),
        child: BlocListener<AvailabeQuizesCubit, AvailabeQuizesState>(
          listener: (context, state) {},
          child: BlocBuilder<AvailabeQuizesCubit, AvailabeQuizesState>(
            builder: (context, state) {
              if (state is AvailabeQuizesSuccess) {
                var data = state.totalQuiz;
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(32.5),
                    vertical: context.h(50),
                  ),
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => AvailableQuizItem(
                      questionNum: data[index].quizes.length,
                      quizName: data[index].quizName,
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentQuiz(
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
      ),
    );
  }
}
