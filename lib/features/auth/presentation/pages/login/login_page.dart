import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_text_form_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

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
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(label: 'Your Email'),
                  CustomTextFormField(label: 'Password'),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        context.push(AppRoutes.resetpassword);
                      },
                      child: Text(
                        "Forget Your Password?",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomButton(text: 'login', onPressed: () {}),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
