import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/context_extension.dart';

class SelectedPhotoPreviews extends StatelessWidget {
  const SelectedPhotoPreviews({
    super.key,
    required this.imagePaths,
    required this.onRemove,
  });

  final List<String> imagePaths;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final radius = context.w(12).clamp(8.0, 14.0);
    final tapSize = context.w(44).clamp(40.0, 48.0);
    return TextFieldTapRegion(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < imagePaths.length; index++)
            Padding(
              key: ValueKey(imagePaths[index]),
              padding: EdgeInsets.only(
                bottom: index < imagePaths.length - 1
                    ? context.h(12).clamp(8.0, 16.0)
                    : 0,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Image.file(
                        File(imagePaths[index]),
                        width: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            ColoredBox(
                              color: AppColors.surfaceLight,
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: AppColors.textSecondary,
                                size: context.w(24).clamp(20.0, 28.0),
                              ),
                            ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: context.h(4).clamp(4.0, 8.0),
                    right: context.w(4).clamp(4.0, 8.0),
                    child: IconButton(
                      tooltip: 'Remove image',
                      onPressed: () => onRemove(index),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tightFor(
                        width: tapSize,
                        height: tapSize,
                      ),
                      style: IconButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: AppColors.black.withValues(
                          alpha: 0.65,
                        ),
                        foregroundColor: AppColors.white,
                      ),
                      icon: Icon(
                        Icons.close,
                        size: context.sp(20).clamp(18.0, 24.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
