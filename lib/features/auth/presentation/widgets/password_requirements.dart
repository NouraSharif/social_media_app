import 'package:flutter/material.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';

class PasswordRequirements extends StatelessWidget {
  const PasswordRequirements({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Must be at least 8 characters with one number and one special character',
      style: AppTextStyles.small.copyWith(fontSize: 10),
    );
  }
}
