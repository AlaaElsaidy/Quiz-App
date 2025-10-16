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
import '../widgets/question-type.dart';
import '../widgets/quiz-item.dart';

class QuizCreationScreen extends StatefulWidget {
  const QuizCreationScreen({super.key});

  @override
  State<QuizCreationScreen> createState() => _QuizCreationScreenState();
}

class _QuizCreationScreenState extends State<QuizCreationScreen> {
  static const int maxQuestions = 10;

  late TextEditingController _quizName;
  final List<Map<String, TextEditingController>> _questionsControllers = [];
  final List<QuestionType> _questionTypes = [];
  final List<int?> _mcqCorrectIndex = [];
  final List<bool> _tfCorrectIsTrue = [];

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
    _questionTypes.add(QuestionType.multipleChoice);
    _mcqCorrectIndex.add(null);
    _tfCorrectIsTrue.add(true);
  }

  @override
  void dispose() {
    _quizName.dispose();
    for (var q in _questionsControllers) {
      for (final controller in q.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _addQuestion() {
    if (_questionsControllers.length >= maxQuestions) {
      ShowCustomDialoge(context, "You cannot add more than $maxQuestions.");
      return;
    }
    setState(() {
      _questionsControllers.add({
        "question": TextEditingController(),
        "option1": TextEditingController(),
        "option2": TextEditingController(),
        "option3": TextEditingController(),
        "option4": TextEditingController(),
        "correct": TextEditingController(),
      });
      _questionTypes.add(QuestionType.multipleChoice);
      _mcqCorrectIndex.add(null);
      _tfCorrectIsTrue.add(true);
    });
  }

  Future<void> _saveQuiz() async {
    if (_quizName.text
        .trim()
        .isEmpty) {
      ShowCustomDialoge(context, "Please enter quiz name");
      return;
    }

    if (_questionsControllers.length > maxQuestions) {
      ShowCustomDialoge(
        context,
        "عدد الأسئلة أكبر من الحد الأقصى ($maxQuestions).",
      );
      return;
    }

    questions.clear();

    for (int i = 0; i < _questionsControllers.length; i++) {
      final q = _questionsControllers[i];
      final type = _questionTypes[i];

      final questionText = q["question"]!.text.trim();
      if (questionText.isEmpty) {
        ShowCustomDialoge(context, "Question ${i + 1}: text is required");
        return;
      }

      List<String> answers = [];
      String correct = "";

      switch (type) {
        case QuestionType.text:
          final ca = q["correct"]!.text.trim();
          if (ca.isEmpty) {
            ShowCustomDialoge(
                context, "Question ${i + 1}: correct answer is required");
            return;
          }
          correct = ca;
          break;

        case QuestionType.multipleChoice:
          final opts = [
            q["option1"]!.text.trim(),
            q["option2"]!.text.trim(),
            q["option3"]!.text.trim(),
            q["option4"]!.text.trim(),
          ];
          if (opts.any((e) => e.isEmpty)) {
            ShowCustomDialoge(
                context, "Question ${i + 1}: all options are required");
            return;
          }
          if (_mcqCorrectIndex[i] == null) {
            ShowCustomDialoge(
                context, "Question ${i + 1}: select the correct option");
            return;
          }
          answers = opts;
          correct = opts[_mcqCorrectIndex[i]!];
          break;

        case QuestionType.trueFalse:
          answers = const ["True", "False"];
          correct = _tfCorrectIsTrue[i] ? "True" : "False";
          break;
      }

      questions.add(
        QuizModel(
          id: i,
          quiz: questionText,
          answers: answers,
          correctAnswer: correct,
        ),
      );
    }

    await quizCubit.saveQUiz(
      totalQuiz: TotalQuiz(
        quizName: _quizName.text.trim(),
        quizes: questions,
      ),
    );
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
                  icon: const Icon(Icons.logout, color: Colors.white),
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
                    SizedBox(height: context.h(10)),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Questions: ${_questionsControllers
                            .length} / $maxQuestions",
                        style: TextStyle(
                          color: AppColors.blackTextColor.withOpacity(0.7),
                          fontSize: context.sp(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: context.h(10)),

                    Column(
                      children: List.generate(
                          _questionsControllers.length, (index) {
                        final q = _questionsControllers[index];
                        return QuizItem(
                          questionNumber: index + 1,
                          type: _questionTypes[index],
                          onTypeChanged: (newType) {
                            setState(() {
                              _questionTypes[index] = newType;
                              _mcqCorrectIndex[index] = null;
                              _tfCorrectIsTrue[index] = true;
                              q["correct"]!.clear();
                            });
                          },
                          question: q["question"]!,
                          option1: q["option1"]!,
                          option2: q["option2"]!,
                          option3: q["option3"]!,
                          option4: q["option4"]!,
                          correctAnswer: q["correct"]!,
                          selectedMcqIndex: _mcqCorrectIndex[index],
                          onSelectMcqIndex: (selected) {
                            setState(() {
                              _mcqCorrectIndex[index] = selected;
                            });
                          },
                          tfCorrectIsTrue: _tfCorrectIsTrue[index],
                          onToggleTrueFalse: (isTrue) {
                            setState(() {
                              _tfCorrectIsTrue[index] = isTrue;
                            });
                          },
                        );
                      }),
                    ),
                    SizedBox(height: context.h(20)),

                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "Add",
                            onClick: _addQuestion,
                          ),
                        ),
                        SizedBox(width: context.w(10)),
                        Expanded(
                          child: CustomButton(
                            text: "Save Quiz",
                            onClick: _saveQuiz,
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