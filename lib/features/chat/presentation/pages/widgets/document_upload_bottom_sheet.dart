import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/core/constants/app_assets.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/utils/context_extension.dart';
import 'package:social_media_app/features/auth/presentation/widgets/image_source_card.dart';

class DocumentUploadBottomSheet extends StatefulWidget {
  const DocumentUploadBottomSheet({super.key});

  @override
  State<DocumentUploadBottomSheet> createState() =>
      _DocumentUploadBottomSheetState();
}

class _DocumentUploadBottomSheetState extends State<DocumentUploadBottomSheet> {
  final ImagePicker picker = ImagePicker();

  Future<void> uploadImageFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null && mounted) {
      Navigator.pop(context, image);
    }
  }

  Future<void> uploadVideoFromCamera() async {
    final XFile? video = await picker.pickVideo(source: ImageSource.camera);

    if (video != null && mounted) {
      Navigator.pop(context, video);
    }
  }

  Future<void> uploadDocument() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (files.isNotEmpty && mounted) {
      Navigator.pop(context, files.single);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(30, 24, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Upload Profile Picture',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: context.h(19)),

          Row(
            spacing: context.w(9),
            children: [
              Expanded(
                child: ImageSourceCard(
                  image: Assets.imagesFromGallery,
                  title: 'Image',
                  onTap: uploadImageFromGallery,
                ),
              ),

              Expanded(
                child: ImageSourceCard(
                  image: Assets.imagesVideoPicture,
                  title: 'Video',
                  onTap: uploadVideoFromCamera,
                ),
              ),

              Expanded(
                child: ImageSourceCard(
                  image: Assets.imagesDocumentPicture,
                  title: 'Document',
                  onTap: uploadDocument,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
