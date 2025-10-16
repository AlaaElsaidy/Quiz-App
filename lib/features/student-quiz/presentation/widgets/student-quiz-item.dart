import 'package:flutter/material.dart';
import 'package:quizzo/config/screen_sizer/size_extension.dart';
import 'package:quizzo/config/utilis/app_colors.dart';

class StudentQuizItem extends StatefulWidget {
  final int questionNumber;
  final String question;
  final List<String> options;
  final String? selectedAnswer;
  final ValueChanged<String> onAnswerSelected;

  const StudentQuizItem({
    super.key,
    required this.questionNumber,
    required this.question,
    required this.options,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  State<StudentQuizItem> createState() => _StudentQuizItemState();
}

class _StudentQuizItemState extends State<StudentQuizItem> {
  late final TextEditingController _textCtrl;

  bool get _isText => widget.options.isEmpty;

  bool get _isTrueFalse {
    if (widget.options.length != 2) return false;
    final s = widget.options.map((e) => e.trim().toLowerCase()).toSet();
    return s.contains('true') && s.contains('false');
  }

  @override
  void initState() {
    super.initState();
    _textCtrl = TextEditingController(text: widget.selectedAnswer ?? '');
  }

  @override
  void didUpdateWidget(covariant StudentQuizItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // لو تغيرت الإجابة المختارة من الأب (مثلاً Reset)
    if (_isText && widget.selectedAnswer != _textCtrl.text) {
      _textCtrl.text = widget.selectedAnswer ?? '';
    }
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMCQ = !_isText && !_isTrueFalse;

    return Container(
      margin: EdgeInsets.only(bottom: context.h(20)),
      padding: EdgeInsets.symmetric(
        horizontal: context.w(24),
        vertical: context.h(24),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.w(16)),
        border: Border.all(color: AppColors.borderColor, width: context.w(2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Question ${widget.questionNumber}",
            style: TextStyle(
              color: AppColors.blackTextColor,
              fontSize: context.sp(18),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: context.h(8)),
          Text(
            widget.question,
            style: TextStyle(
              color: AppColors.blackTextColor,
              fontSize: context.sp(16),
            ),
          ),
          SizedBox(height: context.h(16)),
          if (_isText) ...[
            TextField(
              controller: _textCtrl,
              minLines: 1,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Your answer",
                hintText: "Type your answer here",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              onChanged: widget.onAnswerSelected,
            ),
          ] else if (_isTrueFalse) ...[
            RadioListTile<String>(
              value: "True",
              groupValue: widget.selectedAnswer,
              onChanged: (v) => v != null ? widget.onAnswerSelected(v) : null,
              title: const Text("True"),
              activeColor: AppColors.primaryColor,
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<String>(
              value: "False",
              groupValue: widget.selectedAnswer,
              onChanged: (v) => v != null ? widget.onAnswerSelected(v) : null,
              title: const Text("False"),
              activeColor: AppColors.primaryColor,
              contentPadding: EdgeInsets.zero,
            ),
          ] else if (isMCQ) ...[
            ...List.generate(widget.options.length, (i) {
              final opt = widget.options[i];
              return RadioListTile<String>(
                value: opt,
                groupValue: widget.selectedAnswer,
                onChanged: (v) => v != null ? widget.onAnswerSelected(v) : null,
                title: Text(opt),
                activeColor: AppColors.primaryColor,
                contentPadding: EdgeInsets.zero,
              );
            }),
          ],
        ],
      ),
    );
  }
}