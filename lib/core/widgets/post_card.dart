// lib/features/home/widgets/post_card.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/domain/entities/post_entity.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';
import 'package:social_media_app/core/utils/helper_functions.dart';
import 'stat_ship.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onLikeTap;
  final VoidCallback? onTap;

  const PostCard({
    super.key,
    required this.post,
    required this.onLikeTap,
    this.onTap});

  @override
  Widget build(BuildContext context) {
    final avatarRadius = context.w(20);
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    final imageCacheWidth = (context.w(343) * devicePixelRatio).round();

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 12,
              children: [
                Container(
                  width: avatarRadius * 2,
                  height: avatarRadius * 2,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                    image: post.userAvatarUrl != null
                        ? DecorationImage(
                      image: NetworkImage(post.userAvatarUrl!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: post.userAvatarUrl == null
                      ? Icon(
                    Icons.person,
                    color: AppColors.textSecondary,
                    size: context.w(22),
                  )
                      : null,
                ),
             //   SizedBox(width: context.w(10)),
                Expanded(
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: AppTextStyles.button.copyWith(fontSize: context.sp(15)),
                      ),
                      //SizedBox(height: context.h(5)),
                      Text(post.timeAgo, style: AppTextStyles.small.copyWith(fontSize: context.sp(10))),
                    ],
                  ),
                ),
                Icon(Icons.more_vert, color: AppColors.iconBackground, size: context.w(20)),
              ],
            ),

            if (post.imageUrl != null) ...[
           SizedBox(height: context.h(12)),
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.w(12)),
                    image: DecorationImage(
                      image: ResizeImage(NetworkImage(post.imageUrl!), width: imageCacheWidth),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
         //   SizedBox(height: context.h(10)),
            Text(post.content, style: AppTextStyles.body.copyWith(fontSize: context.sp(14))),

         //  SizedBox(height: context.h(12)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatChip(
                  icon:   CupertinoIcons.hand_thumbsup,
                  label: HelperFunctions.formatCount(post.likesCount),
                  color: post.isLiked ? AppColors.primary : AppColors.iconBackground,
                  onTap: onLikeTap,
                ),
                StatChip(
                  icon: CupertinoIcons.chat_bubble,
                  label: HelperFunctions.formatCount(post.commentsCount),
                  color: AppColors.iconBackground,
                ),
                StatChip(
                  icon: CupertinoIcons.arrow_2_squarepath,
                  label: HelperFunctions.formatCount(post.repostsCount),
                  color:AppColors.iconBackground,
                ),

                Icon(CupertinoIcons.share, size: context.w(18), color: AppColors.iconBackground),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
