import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzo/config/screen_sizer/size_extension.dart';
import 'package:quizzo/config/shared/widgets/custom-button.dart';
import 'package:quizzo/config/shared/widgets/custom-dialoge.dart';
import 'package:quizzo/config/utilis/app_colors.dart';
import 'package:quizzo/features/quiz-creation/data/models/quiz-model.dart';
import 'package:quizzo/features/quiz-creation/data/repositories/quiz-creation-repo.dart';

import '../../../../config/firebase-services/authentication.dart';
import '../../../../config/router/routes.dart';
import '../cubit/quiz_creation_cubit.dart';
import '../widgets/quiz-item.dart';

class QuizCreationScreen extends StatefulWidget {
  const QuizCreationScreen({super.key});

  @override
  State<QuizCreationScreen> createState() => _QuizCreationScreenState();
}

class _QuizCreationScreenState extends State<QuizCreationScreen> {
  late TextEditingController _quizName;
  List<Map<String, TextEditingController>> _questionsControllers = [];
  List<QuizModel> questions = [];

  var quizCubit = QuizCreationCubit(quizCreationRepo: QuizCreationRepo());

  @override
  void initState() {
    super.initState();
    _quizName = TextEditingController();

    // أول سؤال جاهز
    _questionsControllers.add({
      "question": TextEditingController(),
      "option1": TextEditingController(),
      "option2": TextEditingController(),
      "option3": TextEditingController(),
      "option4": TextEditingController(),
      "correct": TextEditingController(),
    });
  }

  @override
  void dispose() {
    _quizName.dispose();
    for (var q in _questionsControllers) {
      q.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => quizCubit,
      child: BlocConsumer<QuizCreationCubit, QuizCreationState>(
        listener: (context, state) {
          if (state is SaveQuizSuccess) {
            ShowCustomDialoge(context, "Quiz saved successfully!");
          } else if (state is SaveQuizFailure) {
            ShowCustomDialoge(context, state.message);
          } else if (state is AddQuizFailure) {
            ShowCustomDialoge(context, state.message);
          } else if (state is AddQuizSuccess) {
            setState(() {});
          }
        },
        builder: (context, state) {
          final cubit = context.read<QuizCreationCubit>();

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
                "Quiz",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: context.sp(28),
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(20)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: context.h(20)),
                      padding: EdgeInsets.all(context.w(20)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(context.w(20)),
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 2,
                        ),
                      ),
                      child: TextField(
                        controller: _quizName,
                        decoration: const InputDecoration(
                          labelText: "Quiz Name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: context.h(20)),

                    // عرض كل الأسئلة
                    Column(
                      children: List.generate(_questionsControllers.length, (
                        index,
                      ) {
                        final q = _questionsControllers[index];
                        return QuizItem(
                          questionNumber: index + 1,
                          question: q["question"]!,
                          option1: q["option1"]!,
                          option2: q["option2"]!,
                          option3: q["option3"]!,
                          option4: q["option4"]!,
                          correctAnswer: q["correct"]!,
                        );
                      }),
                    ),
                    SizedBox(height: context.h(20)),

                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "Add",
                            onClick: () {
                              cubit.addQuestion(_questionsControllers);
                            },
                          ),
                        ),
                        SizedBox(width: context.w(10)),
                        Expanded(
                          child: CustomButton(
                            text: "Save Quiz",
                            onClick: () async {
                              questions.clear();
                              for (
                                int i = 0;
                                i < _questionsControllers.length;
                                i++
                              ) {
                                final q = _questionsControllers[i];
                                questions.add(
                                  QuizModel(
                                    id: i,
                                    quiz: q["question"]!.text,
                                    answers: [
                                      q["option1"]!.text,
                                      q["option2"]!.text,
                                      q["option3"]!.text,
                                      q["option4"]!.text,
                                    ],
                                    correctAnswer: q["correct"]!.text,
                                  ),
                                );
                              }

                              await quizCubit.saveQUiz(
                                totalQuiz: TotalQuiz(
                                  quizName: _quizName.text,
                                  quizes: questions,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(40)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
