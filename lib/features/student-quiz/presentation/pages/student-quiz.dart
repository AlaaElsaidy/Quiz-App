import 'package:flutter/material.dart';
import 'package:quizzo/config/firebase-services/authentication.dart';
import 'package:quizzo/config/router/routes.dart';
import 'package:quizzo/config/screen_sizer/size_extension.dart';
import 'package:quizzo/config/utilis/app_colors.dart';
import 'package:quizzo/features/quiz-creation/data/models/quiz-model.dart';
import 'package:quizzo/features/result/result-screen.dart';
import 'package:quizzo/features/student-quiz/presentation/widgets/student-quiz-item.dart';

import '../../../../config/shared/widgets/custom-button.dart';

class StudentQuiz extends StatefulWidget {
  final List<QuizModel> quizModel;
  String quizName;

  StudentQuiz({super.key, required this.quizModel, required this.quizName});

  @override
  State<StudentQuiz> createState() => _StudentQuizState();
}

class _StudentQuizState extends State<StudentQuiz> {
  Map<int, String?> answers = {};
  int right = 0;
  int wrong = 0;

  void _onAnswerSelected(int index, String value) {
    if (answers[index] == null) {
      setState(() {
        answers[index] = value;

        if (value == widget.quizModel[index].correctAnswer) {
          right++;
        } else {
          wrong++;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          highlightColor: Colors.transparent,
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
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
            icon: Icon(Icons.logout, color: Colors.white),
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

                (index) => StudentQuizItem(
                  questionNumber: widget.quizModel[index].id + 1,
                  question: widget.quizModel[index].quiz,
                  options: widget.quizModel[index].answers,
                  selectedAnswer: answers[index],
                  onAnswerSelected: (value) {
                    _onAnswerSelected(index, value);
                  },
                ),
              ),
              CustomButton(
                onClick: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(
                        score: right,
                        total: widget.quizModel.length,
                        correct: right,
                        wrong: wrong,
                      ),
                    ),
                    (route) => false,
                  );
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
