import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_media_app/features/auth/presentation/pages/auth/widgets/social_login_button.dart';
import 'package:social_media_app/features/auth/presentation/pages/login/login_page.dart';
import 'package:social_media_app/features/auth/presentation/pages/signup/signup_page.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_description.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final scale = (constraints.maxWidth / 335).clamp(0.9, 1.15);
                  final tabSpacing = 91 * scale;
                  return TabBar(
                    padding: EdgeInsets.only(
                      top: 65 * scale,
                      bottom: 14 * scale,
                    ),
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    labelPadding: EdgeInsets.only(right: tabSpacing),
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    tabs: const [
                      Tab(text: 'Login'),
                      Tab(text: 'Sign Up'),
                    ],
                  );
                },
              ),
              const CustomDescription(
                text: 'Please fill below information to access your account!',
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    BlocProvider(
                      create: (_) => AuthBloc(signupUseCase, loginUseCase),
                      child: const LoginPage(),
                    ),
                    BlocProvider(
                      create: (_) => AuthBloc(signupUseCase, loginUseCase),
                      child: const SignUpPage(),
                    ),
                  ],
                ),
              ),
              const Text('Or continue with', style: AppTextStyles.body),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SocialLoginButton(
                    icon: FontAwesomeIcons.google,
                    backgroundColor: Color(0xFFD85140),
                  ),
                  SocialLoginButton(
                    icon: FontAwesomeIcons.facebook,
                    backgroundColor: AppColors.iconColor,
                  ),
                  SocialLoginButton(
                    icon: FontAwesomeIcons.apple,
                    backgroundColor: AppColors.black,
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
