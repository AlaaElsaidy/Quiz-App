import 'package:flutter/material.dart';
import 'package:quizzo/config/screen_sizer/size_extension.dart';

import '../../../../config/utilis/app_colors.dart';

class StudentQuizItem extends StatelessWidget {
  final int questionNumber;
  final String question;
  final List<String> options;
  final String? selectedAnswer; // ✅ علشان نعرف هو اختار إيه
  final ValueChanged<String> onAnswerSelected;

  const StudentQuizItem({
    super.key,
    required this.onAnswerSelected,
    required this.questionNumber,
    required this.question,
    required this.options,
    required this.selectedAnswer,
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
          // رقم السؤال
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryColor.withAlpha(180),
                child: Text(
                  questionNumber.toString(),
                  style: TextStyle(color: AppColors.whiteColor),
                ),
              ),
              SizedBox(width: context.w(15)),
              Expanded(
                child: Text(
                  question,
                  style: TextStyle(
                    fontSize: context.sp(20),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(30)),

          // الاختيارات
          ...options.map((option) {
            final isSelected = selectedAnswer == option;
            return InkWell(
              onTap: () => onAnswerSelected(option),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: context.h(15)),
                padding: EdgeInsets.symmetric(
                  vertical: context.h(15),
                  horizontal: context.w(20),
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor.withOpacity(0.2)
                      : null,
                  borderRadius: BorderRadius.circular(context.w(10)),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.borderColor,
                    width: context.w(1.5),
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: context.sp(18),
                    fontWeight: FontWeight.w400,
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.blackTextColor,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
