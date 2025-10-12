import 'package:flutter/material.dart';
import 'package:quizzo/config/screen_sizer/size_extension.dart';

import '../../../../config/shared/widgets/custom-text-form.dart';
import '../../../../config/utilis/app_colors.dart';

class QuizItem extends StatelessWidget {
  final int questionNumber;
  final TextEditingController question;
  final TextEditingController option1;
  final TextEditingController option2;
  final TextEditingController option3;
  final TextEditingController option4;
  final TextEditingController correctAnswer;

  const QuizItem({
    super.key,
    required this.questionNumber,
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.correctAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(20)),
      padding: EdgeInsets.symmetric(
        horizontal: context.w(40),
        vertical: context.h(40),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.w(20)),
        border: Border.all(color: AppColors.borderColor, width: context.w(2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Question $questionNumber",
            style: TextStyle(
              color: AppColors.blackTextColor,
              fontSize: context.sp(20),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: context.h(10)),

          CustomTextForm(
            textEditingController: question,
            hintText: "Enter question",
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Question cannot be empty";
              }
              return null;
            },
          ),
          SizedBox(height: context.h(20)),

          Text(
            "Options",
            style: TextStyle(
              color: AppColors.blackTextColor,
              fontSize: context.sp(20),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: context.h(10)),

          CustomTextForm(
            textEditingController: option1,
            hintText: "Option 1",
            validator: (String? value) => value!.isEmpty ? "Required" : null,
          ),
          SizedBox(height: context.h(10)),

          CustomTextForm(
            textEditingController: option2,
            hintText: "Option 2",
            validator: (String? value) => value!.isEmpty ? "Required" : null,
          ),
          SizedBox(height: context.h(10)),

          CustomTextForm(
            textEditingController: option3,
            hintText: "Option 3",
            validator: (String? value) => value!.isEmpty ? "Required" : null,
          ),
          SizedBox(height: context.h(10)),

          CustomTextForm(
            textEditingController: option4,
            hintText: "Option 4",
            validator: (String? value) => value!.isEmpty ? "Required" : null,
          ),

          SizedBox(height: context.h(20)),

          Text(
            "Correct Answer",
            style: TextStyle(
              color: AppColors.blackTextColor,
              fontSize: context.sp(20),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: context.h(10)),

          CustomTextForm(
            textEditingController: correctAnswer,
            hintText: "Enter the correct answer",
            validator: (String? value) => value!.isEmpty ? "Required" : null,
          ),
        ],
      ),
    );
  }
}
