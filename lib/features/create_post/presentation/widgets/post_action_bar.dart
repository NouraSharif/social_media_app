import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';

class PostActionBar extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onGifTap;
  final VoidCallback onPostTap;
  final bool isEnabled;

  const PostActionBar({
    super.key,
    required this.onGalleryTap,
    required this.onGifTap,
    required this.onPostTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(15),
        vertical: context.h(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              spacing: 7,
              children: [
                _SquareIconButton(
                  icon: CupertinoIcons.photo,
                  onTap: onGalleryTap,
                ),
                _SquareIconButton(
                  icon: CupertinoIcons.smiley,
                  onTap: onGifTap,
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(context.w(89), context.h(35))
            ),
              onPressed: onPostTap,
              child: Text('Post', style: AppTextStyles.button))

        ],
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SquareIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.w(8)),
      child: Icon(icon, color: AppColors.primary, size: context.sp(28)),
    );
  }
}
