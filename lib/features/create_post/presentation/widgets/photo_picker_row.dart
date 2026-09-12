import 'package:flutter/material.dart';

import 'package:social_media_app/core/constants/app_assets.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';

class PhotoPickerRow extends StatelessWidget {
  final List<String> imagePaths;
  final int? selectedIndex;
  final VoidCallback onAddPhotoTap;
  final ValueChanged<int> onPhotoSelected;

  const PhotoPickerRow({
    super.key,
    required this.imagePaths,
    required this.onAddPhotoTap,
    required this.onPhotoSelected,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final double itemSize = context.w(76);
    return SizedBox(
      height: itemSize,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.w(16)),
        itemCount: imagePaths.length + 1,
        separatorBuilder: (_, __) => SizedBox(width: context.w(8)),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _AddPhotoButton(size: itemSize, onTap: onAddPhotoTap);
          }
          final photoIndex = index - 1;
          final isSelected = selectedIndex == photoIndex;
          return GestureDetector(
            onTap: () => onPhotoSelected(photoIndex),
            child: Container(
              width: itemSize,
              height: itemSize,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.w(12)),
                border: isSelected
                    ? Border.all(color: AppColors.primary, width: 2.5)
                    : null,
                image: DecorationImage(
                  image: NetworkImage(imagePaths[photoIndex]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  final double size;
  final VoidCallback onTap;

  const _AddPhotoButton({required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.orangeSurface,
          borderRadius: BorderRadius.circular(context.w(12)),
        ),
        child: Image.asset(
          Assets.imagesFromGallery,
          width: size * 0.4,
          height: size * 0.4,
        ),
      ),
    );
  }
}

Future<void> showAddPhotoSheet({
  required BuildContext context,
  required VoidCallback onTakePicture,
  required VoidCallback onUploadFromGallery,
}) {
  return showModalBottomSheet(
    showDragHandle: true,
    context: context,
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical
        (top: Radius.circular(context.w(20))),
    ),
    builder: (context) {
      return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              horizontal: context.w(23),
            ),
            children: [
              Text('Upload Picture', style: AppTextStyles.appBarTitle,),
              SizedBox(height: context.h(20)),
              Row(
                spacing: 5,
                children: [
                  _PhotoSourceOption(
                    iconAsset: Assets.imagesTakePicture,
                    label: 'Take a picture',
                    onTap: () {
                      Navigator.of(context).pop();
                      onTakePicture();
                    },
                  ),
                  _PhotoSourceOption(
                    iconAsset: Assets.imagesFromGallery,
                    label: 'From gallery',
                    onTap: () {
                      Navigator.of(context).pop();
                      onUploadFromGallery();
                    },
                  ),
                ],
              ),
            ],
          ),

      );
    },
  );
}

class _PhotoSourceOption extends StatelessWidget {
  final String iconAsset;
  final String label;
  final VoidCallback onTap;

  const _PhotoSourceOption({
    required this.iconAsset,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.w(12)),
      child: Container(
        margin: EdgeInsets.all(4),
        height: context.h(95),
        width: context.w(153),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.iconBackground)
        ),
        child: Column(
          spacing: 10,
          children: [
            Image.asset(iconAsset, width: context.w(40), height: context.w(40)),
            Text(label, style: AppTextStyles.body,)
          ],
        ),

      ),
    );
  }
}
