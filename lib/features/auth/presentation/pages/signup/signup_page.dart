import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/widgets/app_snack_bar.dart';
import 'package:social_media_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:social_media_app/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:social_media_app/features/auth/presentation/bloc/auth/auth_state.dart';
import 'package:social_media_app/features/auth/presentation/validators/auth_validators.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:social_media_app/features/auth/presentation/widgets/password_requirements.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isAbove18 = true;
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          AppSnackBar.showSuccess(context, 'Account created successfully.');
          context.push(AppRoutes.verification);
        }

        if (state is AuthFailure) {
          AppSnackBar.showError(context, state.message);
        }
      },
      builder: (context, state) => Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      label: 'Your Email',
                      controller: emailController,
                      validator: (value) {
                        return AuthValidators.email(value);
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      label: 'Password',
                      controller: passwordController,
                      validator: (value) {
                        return AuthValidators.password(value);
                      },
                      obscureText: obscurePassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: obscurePassword
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      label: 'Confirm your Password',
                      controller: confirmPasswordController,
                      validator: (value) {
                        return AuthValidators.confirmPassword(
                          value,
                          passwordController.text,
                        );
                      },
                      obscureText: obscureConfirmPassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                        icon: obscureConfirmPassword
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
                    ),
                    const SizedBox(height: 10),
                    PasswordRequirements(),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Checkbox(
                          value: isAbove18,
                          fillColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.iconColor;
                            }
                            return AppColors.white;
                          }),
                          onChanged: (value) {
                            setState(() {
                              isAbove18 = value ?? false;
                            });
                          },
                        ),
                        const Text(
                          "Confirm you are above 18 years old",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.0,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    CustomButton(
                      text: 'Sign Up',
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        if (!isAbove18) {
                          AppSnackBar.showWarning(
                            context,
                            'Please confirm that you are above 18 years old.',
                          );
                          return;
                        }
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            SignupRequested(
                              email: emailController.text.trim(),
                              password: passwordController.text,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        style: AppTextStyles.small.copyWith(fontSize: 10),
                        children: [
                          TextSpan(
                            text: "by clicking sign up you agree to the ",
                          ),
                          TextSpan(
                            text: "terms and conditions ",
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // action
                              },
                          ),
                          TextSpan(text: "and our "),
                          TextSpan(
                            text: "privacy policy",
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
