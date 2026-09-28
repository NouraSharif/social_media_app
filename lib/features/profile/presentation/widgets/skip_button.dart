import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        'Skip for now',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
