import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const TabBar(
                padding: EdgeInsets.only(bottom: 15, top: 55),
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                labelPadding: EdgeInsets.only(right: 90),
                tabs: [
                  Tab(text: "Login"),
                  Tab(text: "Sign Up"),
                ],
              ),
              const CustomDescription(
                text: "Please fill below information to access your account!",
              ),
              Expanded(
                child: TabBarView(children: [LoginPage(), SignUpPage()]),
              ),
              const Text("or continue with", style: AppTextStyles.body),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SocialLoginButton(
                    icon: FontAwesomeIcons.google,
                    backgroundColor: const Color(0xFFD85140),
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
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
