import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzo/config/screen_sizer/size_extension.dart';

import '../../utilis/app_colors.dart';

void ShowCustomDialoge(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.w(15)),
      ),
      title: Text(
        "Message:",
        style: GoogleFonts.openSans(
          color: AppColors.blackColor,
          fontSize: context.sp(20),
          fontWeight: FontWeight.w700,
          letterSpacing: context.sp(-1),
        ),
      ),
      content: Text(
        message,
        style: GoogleFonts.openSans(
          color: AppColors.hintText,
          fontSize: context.sp(16),
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(context.w(10))),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Ok",
            style: GoogleFonts.openSans(
              color: AppColors.whiteColor,
              fontSize: context.sp(14),
              letterSpacing: context.sp(0.94),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ),
  );
}
