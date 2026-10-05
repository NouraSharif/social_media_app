import 'package:flutter/material.dart';
import 'package:social_media_app/features/post_details/domain/entities/comment_entity.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/context_extension.dart';

class CommentCard extends StatelessWidget {
  final CommentEntity comment;

  const CommentCard({super.key, required this.comment});

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
              Container(
                width: avatarRadius * 2,
                height: avatarRadius * 2,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(10),
                  image: comment.userAvatarUrl != null
                      ? DecorationImage(
                          image: NetworkImage(comment.userAvatarUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: comment.userAvatarUrl == null
                    ? Icon(
                        Icons.person,
                        color: AppColors.textSecondary,
                        size: context.w(22),
                      )
                    : null,
              ),
              Expanded(
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName,
                      style: AppTextStyles.button.copyWith(
                        fontSize: context.sp(15),
                      ),
                    ),
                    Text(
                      comment.timeAgo,
                      style: AppTextStyles.small.copyWith(
                        fontSize: context.sp(10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            comment.content,
            style: AppTextStyles.body.copyWith(fontSize: context.sp(14)),
          ),
        ],
      ),
    );
  }
}
