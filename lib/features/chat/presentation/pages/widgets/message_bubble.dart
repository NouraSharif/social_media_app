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
  final DateTime messageTime;
  final String? image;

  String _formatTime(DateTime dateTime) {
    final time = dateTime.toLocal();

    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = image?.trim();

    final uri = imageUrl == null ? null : Uri.tryParse(imageUrl);

    final hasValidImage =
        imageUrl != null &&
        imageUrl.isNotEmpty &&
        imageUrl.toLowerCase() != 'null' &&
        uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;

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
            if (hasValidImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
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
                _formatTime(messageTime),
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
