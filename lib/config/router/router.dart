import 'package:flutter/material.dart';
import 'package:quizzo/config/router/routes.dart';
import 'package:quizzo/features/login/presentation/pages/login-screen.dart';
import 'package:quizzo/features/quiz-creation/presentation/pages/quiz-creation-screen.dart';
import 'package:quizzo/features/register/presentation/pages/register-screen.dart';
import 'package:quizzo/features/student-dashboard/presentation/pages/student-dashboard.dart';

class AppRouter {
  static Route onGenerate(RouteSettings settings) {
    //example
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (context) => LoginScreen());

      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (context) => RegisterScreen());

      case AppRoutes.teacherDashboard:
        return MaterialPageRoute(builder: (context) => QuizCreationScreen());
      case AppRoutes.studentDashboard:
        return MaterialPageRoute(builder: (context) => StudentDashboard());

      default:
        return MaterialPageRoute(builder: (context) => SizedBox());
    }
  }
}
