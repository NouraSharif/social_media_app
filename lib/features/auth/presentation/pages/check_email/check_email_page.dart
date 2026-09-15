import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/constants/app_assets.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';
import 'package:social_media_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_media_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:social_media_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_button.dart';

class CheckEmailPage extends StatefulWidget {
  const CheckEmailPage({super.key});

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  String otp = '';
  late String email;
  final GlobalKey<FormState> formstate = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    email = GoRouterState.of(context).extra as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check your Email')),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthResetOtpVerified) {
              context.push(
                AppRoutes.newPassword,
                extra: {'email': email, 'resetToken': state.resetToken},
              );
            }
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('A new OTP has been sent to your email.'),
                ),
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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                SizedBox(height: context.h(164)),
                                Image.asset(Assets.imagesCheckEmail),
                                const SizedBox(height: 22),
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
                                                    fieldSpacing *
                                                        (numberOfFields - 1)) /
                                                numberOfFields)
                                            .clamp(
                                              minFieldWidth,
                                              maxFieldWidth,
                                            );

                                    final totalFieldsWidth =
                                        fieldWidth * numberOfFields;

                                    final remainingSpace =
                                        (availableWidth - totalFieldsWidth)
                                            .clamp(0.0, double.infinity);

                                    final margin =
                                        remainingSpace / (numberOfFields * 2);

                                    return OtpTextField(
                                      numberOfFields: 6,
                                      fieldWidth: fieldWidth,
                                      fieldHeight: fieldHeight,
                                      borderWidth: 1,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: margin,
                                      ),
                                      textStyle: AppTextStyles.textField,
                                      focusedBorderColor: AppColors.focus,
                                      borderRadius: BorderRadius.circular(10),
                                      showFieldAsBox: true,

                                      onCodeChanged: (String code) {},

                                      onSubmit: (String verificationCode) {
                                        otp = verificationCode;
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: 22),
                                CustomButton(
                                  text: 'Verify',
                                  onPressed: () {
                                    if (otp.length == 6) {
                                      context.read<AuthBloc>().add(
                                        VerifyResetOtpRequested(
                                          email: email,
                                          otp: otp,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Please enter the 6-digit code',
                                              ),
                                            ),
                                          );
                                    }
                                  },
                                ),
                                const SizedBox(height: 17),
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
                                            context.read<AuthBloc>().add(
                                              SendResetOtpRequested(
                                                email: email,
                                              ),
                                            );
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
