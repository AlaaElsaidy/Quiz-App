import 'package:flutter/material.dart';
import 'package:quizzo/config/screen_sizer/screen_sizer_utility.dart';

class ScreenSizer extends StatelessWidget {
  final Widget child;
  final Size size;

  const ScreenSizer({super.key, required this.child, required this.size});

  @override
  Widget build(BuildContext context) {
    ScreenSizerUtility.init(designHeight: size.height, designWidth: size.width);

    return child;
  }
}
