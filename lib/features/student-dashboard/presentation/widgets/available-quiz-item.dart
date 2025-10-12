import 'package:flutter/material.dart';
import 'package:quizzo/config/screen_sizer/size_extension.dart';

import '../../../../config/shared/widgets/custom-button.dart';
import '../../../../config/utilis/app_colors.dart';

class AvailableQuizItem extends StatelessWidget {
  AvailableQuizItem({
    super.key,
    required this.questionNum,
    required this.quizName,
    required this.onClick,
  });

  int questionNum;
  String quizName;
  Function onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(20)),
      padding: EdgeInsets.symmetric(
        horizontal: context.w(20),
        vertical: context.h(40),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.w(20)),
        border: Border.all(color: AppColors.borderColor, width: context.w(2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                quizName,
                style: TextStyle(
                  fontSize: context.sp(24),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Icon(
                Icons.auto_stories_outlined,
                color: AppColors.lightGray,
                size: context.w(20),
              ),
              SizedBox(width: context.w(4)),
              Text(
                "${questionNum.toString()} questions",
                style: TextStyle(
                  fontSize: context.sp(18),
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightGray,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(50)),
          CustomButton(
            onClick: () {
              onClick();
            },
            text: "Start Quiz",
          ),
        ],
      ),
    );
  }
}
