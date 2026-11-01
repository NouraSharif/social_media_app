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
    return TextFieldTapRegion(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = context
              .w(68)
              .clamp(56.0, 80.0)
              .clamp(0.0, constraints.maxWidth);
          final radius = context.w(12).clamp(8.0, 14.0);
          final gap = context.w(8).clamp(6.0, 12.0);
          return Wrap(
            spacing: gap,
            runSpacing: context.h(8).clamp(6.0, 12.0),
            children: [
              for (var index = 0; index < imagePaths.length; index++)
                Tooltip(
                  message: 'Tap to remove image',
                  child: GestureDetector(
                    onTap: () => onRemove(index),
                    child: SizedBox(
                      width: size,
                      height: size,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(radius),
                            child: Image.file(
                              File(imagePaths[index]),
                              fit: BoxFit.cover,
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
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              tooltip: 'Remove image',
                              onPressed: () => onRemove(index),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints.tightFor(
                                width: context.w(28).clamp(24.0, 32.0),
                                height: context.w(28).clamp(24.0, 32.0),
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.black.withValues(
                                  alpha: 0.65,
                                ),
                                foregroundColor: AppColors.white,
                              ),
                              icon: Icon(
                                Icons.close,
                                size: context.w(18).clamp(16.0, 20.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
