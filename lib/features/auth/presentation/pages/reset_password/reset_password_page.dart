import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_media_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:social_media_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:social_media_app/features/auth/presentation/validators/auth_validators.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_description.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_text_form_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<FormState> formstate = GlobalKey();

  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset your Password')),
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.push(
              AppRoutes.checkEmail,
              extra: emailController.text.trim(),
            );
          }

          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) => state is AuthLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: formstate,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 14),
                      const CustomDescription(
                        text: "Please enter your registered email to reset your password!",
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextFormField(
                              label: 'Your Email',
                              controller: emailController,
                              validator: (value) {
                                return AuthValidators.email(value);
                              },
                            ),
                            SizedBox(height: 25),
                            CustomButton(
                              text: 'Reset Password',
                              onPressed: () {
                                if (formstate.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                    SendResetOtpRequested(
                                      email: emailController.text.trim(),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const Text(
                            "Remember your Password?",
                            style: AppTextStyles.body,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              context.go(AppRoutes.auth);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              backgroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Text('Back To Login'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
