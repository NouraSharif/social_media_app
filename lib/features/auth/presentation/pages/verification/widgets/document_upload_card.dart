import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_assets.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';
import 'package:social_media_app/features/auth/presentation/widgets/document_upload_bottom_sheet.dart';

class DocumentUploadCard extends StatelessWidget {
  const DocumentUploadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(20)),
      child: Column(
        children: [
          // Front Side
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return const DocumentUploadBottomSheet();
                },
              );
            },
            child: DottedBorder(
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
                    Image.asset(
                      Assets.imagesDownload,
                      width: context.w(40),
                      height: context.h(40),
                    ),
                    SizedBox(height: context.h(8)),
                    Text(
                      'Click to upload front side',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: context.h(12)),
          // Back Side
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return const DocumentUploadBottomSheet();
                },
              );
            },
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                color: Color(0x1F000000),
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
                    Image.asset(
                      Assets.imagesDownload,
                      width: context.w(40),
                      height: context.h(40),
                    ),
                    SizedBox(height: context.h(8)),
                    Text(
                      'Click to upload back side',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
