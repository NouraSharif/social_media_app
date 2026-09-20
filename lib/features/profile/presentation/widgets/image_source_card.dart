import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';

class ImageSourceCard extends StatelessWidget {
  const ImageSourceCard({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
  });

  final String image;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: context.h(95),
        width: context.w(153),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.black.withValues(alpha: 0.12),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: context.w(40), height: context.h(40)),
            SizedBox(height: context.h(8)),
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
