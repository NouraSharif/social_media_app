import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/context_extension.dart';
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
      body: Form(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 14),
                      const CustomDescription(
                        text: "Please enter your new password with confirmation and don't share it with others!",
                      ),
                      SizedBox(height: context.h(107)),
                      CustomTextFormField(label: 'New Password'),
                      const SizedBox(height: 14),
                      CustomTextFormField(label: 'Confirm Password'),
                      const SizedBox(height: 10),
                      PasswordRequirements(),
                      const SizedBox(height: 20),
                      CustomButton(text: 'Update', onPressed: () {}),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
