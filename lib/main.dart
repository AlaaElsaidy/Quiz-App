import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizzo/features/login/presentation/pages/login-screen.dart';
import 'package:quizzo/features/quiz-creation/presentation/pages/quiz-creation-screen.dart';
import 'package:quizzo/features/register/presentation/pages/register-screen.dart';
import 'package:quizzo/features/student-dashboard/presentation/pages/student-dashboard.dart';
import 'config/Theme/app_theme.dart';
import 'config/router/router.dart';
import 'config/router/routes.dart';
import 'config/screen_sizer/ScreenSizer.dart';
import 'config/shared-prefrences/shared-prefrences-helper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsHelper.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenSizer(
      size: const Size(430, 932),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.login,
        onGenerateRoute: AppRouter.onGenerate,
        // home: Builder(builder: (context) => StudentDashboard()),
        themeMode: ThemeMode.system,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
      ),
    );
  }
}
