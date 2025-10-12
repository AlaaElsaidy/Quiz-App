import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzo/config/screen_sizer/size_extension.dart';

import '../../../../config/utilis/app_colors.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.onClick,
    required this.text,
    this.bgColor,
    this.textColor,
  });

  Function onClick;
  String text;
  Color? textColor;
  Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h(60),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          onClick();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.w(10)),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            color: textColor ?? AppColors.whiteColor,
            fontSize: context.sp(20),
            letterSpacing: context.sp(0.94),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
