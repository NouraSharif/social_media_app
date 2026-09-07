import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_assets.dart';
import 'package:social_media_app/features/auth/presentation/pages/verification/widgets/custom_dotted_border.dart';
import 'package:social_media_app/features/auth/presentation/widgets/document_upload_bottom_sheet.dart';

class DocumentUploadCard extends StatelessWidget {
  const DocumentUploadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
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
            child: CustomDottedBorder(
              title: 'Click to upload front side',
              image: Assets.imagesDownload,
            ),
          ),
          const SizedBox(height: 12),
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
            child: CustomDottedBorder(
              title: 'Click to upload back side',
              image: Assets.imagesDownload,
            ),
          ),
        ],
      ),
    );
  }
}
