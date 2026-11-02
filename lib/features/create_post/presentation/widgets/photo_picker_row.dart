import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:social_media_app/core/constants/app_assets.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';

class PhotoPickerRow extends StatelessWidget {
  final Set<String> selectedSuggestions;
  final VoidCallback onAddPhotoTap;
  final ValueChanged<String> onSuggestionTap;

  const PhotoPickerRow({
    super.key,
    required this.selectedSuggestions,
    required this.onAddPhotoTap,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final itemSize = context.w(68).clamp(56.0, 80.0);
    final radius = BorderRadius.circular(context.w(12).clamp(8.0, 14.0));
    const suggestions = [
      Assets.imagesCategoriesPicsC1,
      Assets.imagesCategoriesPicsC2,
      Assets.imagesCategoriesPicsC3,
      Assets.imagesCategoriesPicsC4,
    ];
    final available = suggestions
        .where((asset) => !selectedSuggestions.contains(asset))
        .toList();
    return SizedBox(
      height: itemSize,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: context.w(16).clamp(12.0, 24.0),
        ),
        itemCount: available.length + 1,
        separatorBuilder: (context, index) =>
            SizedBox(width: context.w(8).clamp(6.0, 12.0)),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _AddPhotoButton(size: itemSize, onTap: onAddPhotoTap);
          }
          final asset = available[index - 1];
          return Semantics(
            key: ValueKey(asset),
            button: true,
            label: 'Add suggested photo',
            child: Material(
              borderRadius: radius,
              clipBehavior: Clip.antiAlias,
              child: Ink.image(
                image: AssetImage(asset),
                width: itemSize,
                height: itemSize,
                fit: BoxFit.cover,
                child: InkWell(
                  borderRadius: radius,
                  splashColor: AppColors.primary.withValues(alpha: 0.25),
                  onTap: () => onSuggestionTap(asset),
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
          borderRadius: BorderRadius.circular(context.w(12).clamp(8.0, 14.0)),
        ),
        child: Center(
          child: Icon(
            CupertinoIcons.photo,
            color: AppColors.primary,
            size: context.sp(28).clamp(24.0, 32.0),
          ),
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
    isScrollControlled: true,
    useSafeArea: true,
    constraints: BoxConstraints(
      maxWidth: 560,
      maxHeight: context.screenHeight * 0.9,
    ),
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(context.w(20).clamp(16.0, 24.0)),
      ),
    ),
    builder: (context) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(
              context.w(23).clamp(16.0, 28.0),
              0,
              context.w(23).clamp(16.0, 28.0),
              context.h(20).clamp(12.0, 24.0),
            ),
            children: [
              Text(
                'Upload Picture',
                style: AppTextStyles.appBarTitle.copyWith(
                  fontSize: context.sp(24).clamp(20.0, 26.0),
                ),
              ),
              SizedBox(height: context.h(20).clamp(12.0, 24.0)),
              LayoutBuilder(
                builder: (context, constraints) {
                  final fontSize = context.sp(14).clamp(14.0, 16.0);
                  final stackOptions =
                      constraints.maxWidth < 300 ||
                      MediaQuery.textScalerOf(context).scale(fontSize) /
                              fontSize >=
                          1.3;
                  final gap = context.w(9).clamp(8.0, 12.0);
                  final options = [
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
                  ];
                  if (stackOptions) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        options[0],
                        SizedBox(height: gap),
                        options[1],
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: options[0]),
                      SizedBox(width: gap),
                      Expanded(child: options[1]),
                    ],
                  );
                },
              ),
            ],
          ),
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
    final iconSize = context.w(40).clamp(32.0, 48.0);
    final radius = context.w(10).clamp(8.0, 12.0);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: context.h(15).clamp(12.0, 20.0),
          horizontal: context.w(12).clamp(8.0, 16.0),
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: AppColors.iconBackground),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(iconAsset, width: iconSize, height: iconSize),
            SizedBox(height: context.h(10).clamp(8.0, 12.0)),
            Text(
              label,
              textAlign: TextAlign.center,
              softWrap: true,
              style: AppTextStyles.body.copyWith(
                fontSize: context.sp(14).clamp(14.0, 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
