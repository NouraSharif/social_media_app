import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:social_media_app/features/auth/presentation/widgets/password_requirements.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final GlobalKey<FormState> formstate = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formstate,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(label: 'Your Email'),
                  CustomTextFormField(label: 'Password'),
                  CustomTextFormField(label: 'Confirm your Password'),
                  PasswordRequirements(),
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.iconColor;
                          }
                          return Colors.white;
                        }),
                        onChanged: (value) {},
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
                  CustomButton(
                    text: 'Sign Up',
                    onPressed: () {
                      context.push(AppRoutes.verification);
                    },
                  ),
                  SizedBox(height: 1),
                  Text.rich(
                    TextSpan(
                      style: AppTextStyles.small.copyWith(fontSize: 10),
                      children: [
                        TextSpan(text: "by clicking sign up you agree to the "),
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
    );
  }
}
