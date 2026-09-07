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

  Future<void> uploadFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null && mounted) {
      debugPrint('=========================${image.path}');
      Navigator.pop(context, image);
    }
  }

  Future<void> uploadFromCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null && mounted) {
      debugPrint(photo.path);
      Navigator.pop(context, photo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.h(198),
      padding: const EdgeInsets.fromLTRB(
        30, // left
        24, // top
        30, // right
        30, // bottom
      ),
      child: Column(
        children: [
          Text(
            "Upload Profile Picture",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.h(19)),
          Row(
            children: [
              ImageSourceCard(
                image: Assets.imagesFromGallery,
                title: 'From Gallery',
                onTap: () {
                  uploadFromGallery();
                },
              ),
              SizedBox(width: context.w(9)),
              ImageSourceCard(
                image: Assets.imagesTakePicture,
                title: 'Take Picture',
                onTap: () {
                  uploadFromCamera();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
