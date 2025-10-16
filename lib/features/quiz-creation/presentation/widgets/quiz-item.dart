import 'package:flutter/material.dart';
import 'package:quizzo/config/screen_sizer/size_extension.dart';
import 'package:quizzo/features/quiz-creation/presentation/widgets/question-type.dart';

import '../../../../config/shared/widgets/custom-text-form.dart';
import '../../../../config/utilis/app_colors.dart';

class QuizItem extends StatelessWidget {
  final int questionNumber;
  final QuestionType type;
  final ValueChanged<QuestionType>? onTypeChanged;
  final TextEditingController question;
  final TextEditingController option1;
  final TextEditingController option2;
  final TextEditingController option3;
  final TextEditingController option4;
  final TextEditingController correctAnswer;

  final int? selectedMcqIndex;
  final ValueChanged<int>? onSelectMcqIndex;

  final bool tfCorrectIsTrue;
  final ValueChanged<bool>? onToggleTrueFalse;

  const QuizItem({
    super.key,
    required this.questionNumber,
    required this.type,
    this.onTypeChanged,
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.correctAnswer,
    required this.selectedMcqIndex,
    this.onSelectMcqIndex,
    required this.tfCorrectIsTrue,
    this.onToggleTrueFalse,
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
          Row(
            children: [
              Expanded(
                child: Text(
                  "Question $questionNumber",
                  style: TextStyle(
                    color: AppColors.blackTextColor,
                    fontSize: context.sp(20),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              DropdownButton<QuestionType>(
                value: type,
                onChanged: (val) {
                  if (val != null) onTypeChanged?.call(val);
                },
                items: QuestionType.values
                    .map(
                      (t) =>
                      DropdownMenuItem(
                        value: t,
                        child: Text(t.label),
                      ),
                )
                    .toList(),
              ),
            ],
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

          if (type == QuestionType.multipleChoice) ...[
            Text(
              "Options",
              style: TextStyle(
                color: AppColors.blackTextColor,
                fontSize: context.sp(20),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: context.h(10)),

            _OptionWithRadio(
              index: 0,
              label: "Option 1",
              controller: option1,
              groupValue: selectedMcqIndex,
              onChanged: onSelectMcqIndex,
            ),
            SizedBox(height: context.h(10)),

            _OptionWithRadio(
              index: 1,
              label: "Option 2",
              controller: option2,
              groupValue: selectedMcqIndex,
              onChanged: onSelectMcqIndex,
            ),
            SizedBox(height: context.h(10)),

            _OptionWithRadio(
              index: 2,
              label: "Option 3",
              controller: option3,
              groupValue: selectedMcqIndex,
              onChanged: onSelectMcqIndex,
            ),
            SizedBox(height: context.h(10)),

            _OptionWithRadio(
              index: 3,
              label: "Option 4",
              controller: option4,
              groupValue: selectedMcqIndex,
              onChanged: onSelectMcqIndex,
            ),
          ] else
            if (type == QuestionType.trueFalse) ...[
              Text(
                "Correct Answer",
                style: TextStyle(
                  color: AppColors.blackTextColor,
                  fontSize: context.sp(20),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: context.h(10)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      value: true,
                      groupValue: tfCorrectIsTrue,
                      onChanged: (v) => onToggleTrueFalse?.call(v ?? true),
                      title: const Text("True"),
                      activeColor: AppColors.primaryColor,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      value: false,
                      groupValue: tfCorrectIsTrue,
                      onChanged: (v) => onToggleTrueFalse?.call(v ?? false),
                      title: const Text("False"),
                      activeColor: AppColors.primaryColor,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ] else
              ...[
                // Text question: إجابة نصية صحيحة
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
                  validator: (String? value) =>
                  value!.isEmpty
                      ? "Required"
                      : null,
                ),
              ],
        ],
      ),
    );
  }
}

class _OptionWithRadio extends StatelessWidget {
  final int index;
  final String label;
  final TextEditingController controller;
  final int? groupValue;
  final ValueChanged<int>? onChanged;

  const _OptionWithRadio({
    required this.index,
    required this.label,
    required this.controller,
    required this.groupValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<int>(
          value: index,
          groupValue: groupValue,
          onChanged: (v) {
            if (v != null) onChanged?.call(v);
          },
          activeColor: AppColors.primaryColor,
        ),
        Expanded(
          child: CustomTextForm(
            textEditingController: controller,
            hintText: label,
            validator: (String? value) => value!.isEmpty ? "Required" : null,
          ),
        ),
      ],
    );
  }
}