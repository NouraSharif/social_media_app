import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';

class CustomImagePickerBox extends StatelessWidget {
  final String title;
  final String assetIcon;
  final VoidCallback onTap;

  const CustomImagePickerBox({
    super.key,
    required this.title,
    required this.assetIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: context.w(335),
        height: context.h(95),
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            color: const Color(0x1F000000),
            strokeWidth: 1,
            dashPattern: const [6, 4],
            radius: const Radius.circular(10),
            padding: EdgeInsets.zero,
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(assetIcon, width: 40, height: 40),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
