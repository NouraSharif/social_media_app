import 'package:flutter/material.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';

class CustomDescription extends StatelessWidget {
  final String text;

  const CustomDescription({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(text, style: AppTextStyles.body),
    );
  }
}
