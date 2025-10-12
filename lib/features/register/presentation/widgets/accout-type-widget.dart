import 'package:flutter/material.dart';
import 'package:quizzo/config/screen_sizer/size_extension.dart';
import 'package:quizzo/config/utilis/app_colors.dart';

class AccountTypeWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isSelected;
  final ValueChanged<String> onSelected;

  const AccountTypeWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isSelected
        ? AppColors.primaryColor
        : AppColors.lightGray;

    return InkWell(
      borderRadius: BorderRadius.circular(context.w(12)),
      onTap: () => onSelected(text),
      child: Container(
        height: context.h(150),
        width: context.w(180),
        decoration: BoxDecoration(
          color: AppColors.filledColor,
          borderRadius: BorderRadius.circular(context.w(12)),
          border: Border.all(color: activeColor, width: context.w(2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: activeColor, size: context.w(35)),
            Text(
              text,
              style: TextStyle(
                color: activeColor,
                fontWeight: FontWeight.w400,
                fontSize: context.sp(18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
