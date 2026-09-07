import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';

class CustomDottedBorder extends StatelessWidget {
  final String title;
  final String image;

  const CustomDottedBorder({
    super.key,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        color: const Color(0x1F000000),
        strokeWidth: 1,
        dashPattern: const [6, 4],
        radius: const Radius.circular(10),
        padding: EdgeInsets.zero,
      ),
      child: SizedBox(
        width: context.w(295),
        height: context.h(155),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: 40, height: 40),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
