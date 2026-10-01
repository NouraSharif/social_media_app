import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.isCurrentUser,
    required this.messageText,
    required this.messageTime,
    this.image,
  });
  final bool isCurrentUser;
  final String messageText;
  final String messageTime;
  final Uint8List? image;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? AppColors.surfaceLight
              : AppColors.orangeSurface,
          borderRadius: isCurrentUser
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                )
              : BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 3,
          children: [
            if (image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  image!,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            if (messageText.trim().isNotEmpty)
              Text(
                messageText,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                messageTime,
                style: AppTextStyles.small.copyWith(
                  color: const Color(0xFF91999E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
