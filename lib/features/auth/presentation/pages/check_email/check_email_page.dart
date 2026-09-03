import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/constants/app_assets.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_button.dart';

class CheckEmailPage extends StatelessWidget {
  CheckEmailPage({super.key});

  final GlobalKey<FormState> formstate = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check your Email')),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: formstate,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Assets.imagesCheckEmail),
                LayoutBuilder(
                  builder: (context, constraints) {
                    const numberOfFields = 6;
                    const maxFieldWidth = 46.0;
                    const minFieldWidth = 40.0;
                    const fieldHeight = 50.0;
                    const fieldSpacing = 10.0;

                    final availableWidth = constraints.maxWidth;

                    final fieldWidth =
                        ((availableWidth -
                                    fieldSpacing * (numberOfFields - 1)) /
                                numberOfFields)
                            .clamp(minFieldWidth, maxFieldWidth);

                    final totalFieldsWidth = fieldWidth * numberOfFields;

                    final remainingSpace = (availableWidth - totalFieldsWidth)
                        .clamp(0.0, double.infinity);

                    final margin = remainingSpace / (numberOfFields * 2);

                    return OtpTextField(
                      numberOfFields: numberOfFields,
                      fieldWidth: fieldWidth,
                      fieldHeight: fieldHeight,
                      borderWidth: 1,
                      margin: EdgeInsets.symmetric(horizontal: margin),
                      textStyle: AppTextStyles.textField,
                      focusedBorderColor: AppColors.focus,
                      borderRadius: BorderRadius.circular(10),
                      showFieldAsBox: true,

                      onCodeChanged: (String code) {},

                      onSubmit: (String verificationCode) {},
                    );
                  },
                ),
                CustomButton(
                  text: 'Verify',
                  onPressed: () {
                    context.push(AppRoutes.newpassword);
                  },
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Did not receive the email?',
                        style: AppTextStyles.small,
                      ),
                      TextSpan(
                        text: ' Resend',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle the tap event here
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
