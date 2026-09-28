import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/core/constants/app_assets.dart';
import 'package:social_media_app/features/auth/presentation/pages/verification/widgets/custom_dotted_border.dart';
import 'package:social_media_app/features/auth/presentation/widgets/document_upload_bottom_sheet.dart';

class DocumentUploadCard extends StatefulWidget {
  final ValueChanged<File?> onFrontChanged;
  final ValueChanged<File?> onBackChanged;

  const DocumentUploadCard({
    super.key,
    required this.onFrontChanged,
    required this.onBackChanged,
  });

  @override
  State<DocumentUploadCard> createState() => _DocumentUploadCardState();
}

class _DocumentUploadCardState extends State<DocumentUploadCard> {
  File? frontImage;
  File? backImage;

  Future<void> pickFrontImage() async {
    final XFile? image = await showModalBottomSheet<XFile>(
      context: context,
      builder: (context) {
        return const DocumentUploadBottomSheet();
      },
    );
    if (image != null) {
      setState(() {
        frontImage = File(image.path);
      });
      widget.onFrontChanged(frontImage);
    }
  }

  Future<void> pickBackImage() async {
    final XFile? image = await showModalBottomSheet<XFile>(
      context: context,
      builder: (context) {
        return const DocumentUploadBottomSheet();
      },
    );
    if (image != null) {
      setState(() {
        backImage = File(image.path);
      });
      widget.onBackChanged(backImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Front Side
          InkWell(
            onTap: pickFrontImage,
            child: CustomDottedBorder(
              title: frontImage == null
                  ? 'Click to upload front side'
                  : 'Front side selected',
              image: Assets.imagesDownload,
              selectedImage: frontImage,
            ),
          ),
          const SizedBox(height: 12),
          //Back Side
          InkWell(
            onTap: pickBackImage,
            child: CustomDottedBorder(
              title: backImage == null
                  ? 'Click to upload back side'
                  : 'Back side selected',
              image: Assets.imagesDownload,
              selectedImage: backImage,
            ),
          ),
        ],
      ),
    );
  }
}
