import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzo/config/firebase-services/firebase-firestore.dart';
import 'package:quizzo/config/router/routes.dart';
import 'package:quizzo/config/screen_sizer/size_extension.dart';
import 'package:quizzo/config/shared-prefrences/shared-prefrences-helper.dart';
import 'package:quizzo/config/shared/valdation/validator.dart';
import 'package:quizzo/config/shared/widgets/custom-button.dart';
import 'package:quizzo/config/shared/widgets/custom-dialoge.dart';
import 'package:quizzo/config/shared/widgets/custom-text-form.dart';
import 'package:quizzo/config/shared/widgets/loading.dart';
import 'package:quizzo/config/utilis/app_colors.dart';
import 'package:quizzo/features/login/data/repositories/login-repo.dart';
import 'package:quizzo/features/login/presentation/cubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  LoginCubit loginCubit = LoginCubit(LoginRepo());

  @override
  void initState() {
    _passwordController = TextEditingController();
    _emailController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => loginCubit,
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) async {
            if (state is LoginFailure) {
              ShowCustomDialoge(context, state.errorMessage);
            }
            if (state is LoginSuccess) {
              var user = await FirebaseFireStrore.getUser(
                id: SharedPrefsHelper.getString(
                  _emailController.text,
                ).toString(),
              );
              if (user.type == "Teacher") {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.teacherDashboard,
                  (route) => false,
                );
              } else {
                print("object");
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.studentDashboard,
                  (route) => false,
                );
              }
            }
          },
          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              if (state is LoginLoading) {
                return LoadingPage();
              }
              return Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: context.w(32.5),
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: context.h(50)),
                      Text(
                        "Welcome Back! Glad \nTo See You, Again!",
                        style: TextStyle(
                          fontSize: context.sp(32),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: context.h(70)),
                      CustomTextForm(
                        textEditingController: _emailController,
                        validator: (String? value) {
                          return emailValidator(value);
                        },
                        hintText: "Enter your email",
                      ),
                      SizedBox(height: context.h(20)),
                      CustomTextForm(
                        secure: true,
                        textEditingController: _passwordController,
                        validator: (String? value) {
                          return passwordValidator(value);
                        },
                        hintText: "Enter your password",
                      ),
                      SizedBox(height: context.h(32)),
                      CustomButton(
                        onClick: () async {
                          if (_formKey.currentState!.validate()) {
                            await loginCubit.login(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                          }
                        },
                        text: "Login",
                      ),
                      SizedBox(height: context.h(32)),
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: "Don’t have an account?",
                            style: TextStyle(
                              color: AppColors.blackTextColor,
                              fontSize: context.sp(16),
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.signUp,
                                    );
                                  },
                                text: "Register Now",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: context.sp(16),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
