import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_description.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_text_form_field.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});

  final GlobalKey<FormState> formstate = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset your Password')),
      resizeToAvoidBottomInset: false,
      body: Form(
        key: formstate,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            children: [
              const CustomDescription(
                text: "Please enter your registered email to reset your password!",
              ),
              const Spacer(),
              Column(
                spacing: 20,
                children: [
                  CustomTextFormField(label: 'Your Email'),
                  CustomButton(
                    text: 'Reset Password',
                    onPressed: () {
                      context.push(AppRoutes.checkEmail);
                    },
                  ),
                ],
              ),
              const Spacer(),
              Column(
                spacing: 10,
                children: [
                  const Text(
                    "Remember your Password?",
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
