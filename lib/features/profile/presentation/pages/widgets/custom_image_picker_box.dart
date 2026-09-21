import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';

class CustomImagePickerBox extends StatelessWidget {
  final String title;
  final String assetIcon;
  final VoidCallback onTap;
  final XFile? image;

  const CustomImagePickerBox({
    super.key,
    required this.title,
    required this.assetIcon,
    required this.onTap,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.w(335),
      height: context.h(95),
      child: image == null
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
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
                      Image.asset(
                        assetIcon,
                        width: context.w(40),
                        height: context.h(40),
                      ),
                      SizedBox(height: context.h(8)),
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
            )
          : Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: context.w(81),
                    height: context.h(81),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(File(image!.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: -context.h(15),
                    left: context.w(25),
                    child: InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(context.w(20)),
                      child: Container(
                        width: context.w(40),
                        height: context.h(40),
                        decoration: BoxDecoration(
                          color: AppColors.iconBackground,
                          borderRadius: BorderRadius.circular(context.w(20)),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: context.w(22),
                          color: AppColors.iconColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
