import 'package:flutter/cupertino.dart';
import 'package:social_media_app/features/post_details/domain/entities/comment_entity.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/context_extension.dart';
import '../../../../core/utils/helper_functions.dart';
import '../../../posts/presentation/widgets/stat_chip.dart';
import '../../../../core/widgets/author_avatar.dart';

class CommentCard extends StatelessWidget {
  final CommentEntity comment;
  final VoidCallback? onLikeTap;

  const CommentCard({super.key, required this.comment, this.onLikeTap});

  @override
  Widget build(BuildContext context) {
    final avatarRadius = context.w(20);

    return Container(
      padding: EdgeInsets.fromLTRB(28, 14, 14, 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10,
            children: [
              AuthorAvatar(
                key: ValueKey(comment.authorId),
                authorId: comment.authorId,
                fallbackUrl: comment.userAvatarUrl,
                size: avatarRadius * 2,
              ),
              Expanded(
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      maxLines:1,
                      overflow:TextOverflow.ellipsis,
                      comment.userName,
                      style: AppTextStyles.button.copyWith(
                        fontSize: context.sp(15),
                      ),
                    ),
                    Text(
                      comment.timeAgo,
                      style: AppTextStyles.small.copyWith(
                        fontSize: context.sp(10),
                        color: AppColors.textPrimary
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            comment.content,
            style: AppTextStyles.small.copyWith(color: AppColors.black),
          ),
          Row(
            spacing: context.w(65),
            children: [
              StatChip(
                icon: comment.isLiked
                    ? CupertinoIcons.hand_thumbsup_fill
                    : CupertinoIcons.hand_thumbsup,
                label: HelperFunctions.formatCount(comment.likesCount),
                color: comment.isLiked
                    ? AppColors.primary
                    : AppColors.secondaryIconColor,
                onTap: onLikeTap,
              ),
              StatChip(
                icon: CupertinoIcons.arrow_2_squarepath,
                label: HelperFunctions.formatCount(0),
                color: AppColors.secondaryIconColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
