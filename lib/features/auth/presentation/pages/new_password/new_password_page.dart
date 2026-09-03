import 'package:flutter/material.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_description.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:social_media_app/features/auth/presentation/widgets/password_requirements.dart';

class NewPasswordPage extends StatelessWidget {
  const NewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Password')),
      resizeToAvoidBottomInset: false,
      body: Form(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            spacing: 20,
            children: [
              const CustomDescription(
                text: "Please enter your new password with confirmation and don't share it with others!",
              ),
              const Spacer(),
              CustomTextFormField(label: 'New Password'),
              CustomTextFormField(label: 'Confirm Password'),
              PasswordRequirements(),
              CustomButton(text: 'Update', onPressed: () {}),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
