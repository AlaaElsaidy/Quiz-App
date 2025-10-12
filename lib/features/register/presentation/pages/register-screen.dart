import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzo/config/firebase-services/firebase-firestore.dart';
import 'package:quizzo/config/router/routes.dart';
import 'package:quizzo/config/screen_sizer/size_extension.dart';
import 'package:quizzo/config/shared/widgets/custom-dialoge.dart';
import 'package:quizzo/config/shared/widgets/loading.dart';
import 'package:quizzo/config/utilis/app_colors.dart';
import 'package:quizzo/features/login/data/models/userModel.dart';
import 'package:quizzo/features/register/data/repositories/register-repo.dart';
import 'package:quizzo/features/register/presentation/cubit/register_cubit.dart';
import 'package:quizzo/features/register/presentation/widgets/accout-type-widget.dart';

import '../../../../config/shared-prefrences/shared-prefrences-helper.dart'
    show SharedPrefsHelper;
import '../../../../config/shared/valdation/validator.dart';
import '../../../../config/shared/widgets/custom-button.dart';
import '../../../../config/shared/widgets/custom-text-form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;
  late TextEditingController _passwordConfirmController;

  final _formKey = GlobalKey<FormState>();
  RegisterCubit registerCubit = RegisterCubit(RegisterRepo());

  String? selectedType;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => registerCubit,
        child: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) async {
            if (state is RegisterFailure) {
              ShowCustomDialoge(context, state.errorMessage);
            } else if (state is RegisterSuccess) {
              UserModel userModel = UserModel(
                id: state.userCredential.user!.uid,
                name: _nameController.text,
                email: _emailController.text,
                type: selectedType!,
              );
              SharedPrefsHelper.saveString(
                _emailController.text,
                state.userCredential.user!.uid,
              );

              FirebaseFireStrore.addUser(userModel, _passwordController.text);
              if (!context.mounted) return;

              if (selectedType == "Teacher") {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.teacherDashboard,
                  (route) => false,
                );
              } else {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.studentDashboard,
                  (route) => false,
                );
              }
            }
          },
          child: BlocBuilder<RegisterCubit, RegisterState>(
            builder: (BuildContext context, state) {
              if (state is RegisterLoading) {
                return const LoadingPage();
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(32.5)),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    child: Column(
                      children: [
                        SizedBox(height: context.h(100)),
                        Text(
                          "Hello! Register To Get Started",
                          style: TextStyle(
                            fontSize: context.sp(32),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: context.h(30)),
                        Text(
                          "Choose your account Type",
                          style: TextStyle(
                            color: AppColors.lightGray,
                            fontSize: context.sp(20),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: context.h(20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AccountTypeWidget(
                              text: "Student",
                              icon: Icons.school_outlined,
                              isSelected: selectedType == "Student",
                              onSelected: (value) {
                                setState(() {
                                  selectedType = value;
                                });
                              },
                            ),
                            AccountTypeWidget(
                              text: "Teacher",
                              icon: Icons.account_circle_outlined,
                              isSelected: selectedType == "Teacher",
                              onSelected: (value) {
                                setState(() {
                                  selectedType = value;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: context.h(30)),
                        CustomTextForm(
                          textEditingController: _nameController,
                          validator: (String? value) {
                            return nameValidator(value);
                          },
                          hintText: "Enter your name",
                        ),
                        SizedBox(height: context.h(20)),
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
                        SizedBox(height: context.h(20)),
                        CustomTextForm(
                          secure: true,
                          textEditingController: _passwordConfirmController,
                          validator: (String? value) {
                            return confirmPasswordValidator(
                              value,
                              _passwordController.text,
                            );
                          },
                          hintText: "Confirm password",
                        ),
                        SizedBox(height: context.h(32)),
                        CustomButton(
                          onClick: () {
                            if (selectedType == null) {
                              ShowCustomDialoge(
                                context,
                                "Please select account type",
                              );
                              return;
                            }
                            if (_formKey.currentState!.validate()) {
                              context.read<RegisterCubit>().register(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                            }
                          },
                          text: "Register",
                        ),
                        SizedBox(height: context.h(32)),
                        Center(
                          child: Text.rich(
                            TextSpan(
                              text: "Already have an account? ",
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
                                        AppRoutes.login,
                                      );
                                    },
                                  text: "Login Now",
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
                        SizedBox(height: context.h(30)),
                      ],
                    ),
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
