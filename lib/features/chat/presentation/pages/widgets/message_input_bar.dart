import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';

class MessageInputBar extends StatelessWidget {
  const MessageInputBar({
    super.key,
    required this.controller,
    required this.onAttachmentPressed,
    required this.onSendPressed,
    this.selectedImage,
    this.isSending = false,
    required this.focusNode,
    this.onRemoveImage,
  });

  final TextEditingController controller;
  final VoidCallback onAttachmentPressed;
  final VoidCallback onSendPressed;
  final Uint8List? selectedImage;
  final bool isSending;
  final FocusNode focusNode;
  final VoidCallback? onRemoveImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            enabled: true,
            focusNode: focusNode,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) {
              if (!isSending) onSendPressed();
            },
            maxLines: null,
            minLines: 1,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceLight,
              hintText: isSending
                  ? 'Sending message...'
                  : 'Type your message ..',
              hintStyle: const TextStyle(color: Color(0xFF91999E)),

              prefixIcon: selectedImage != null
                  ? Padding(
                      padding: const EdgeInsets.all(6),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                selectedImage!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: -5,
                              right: -5,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: isSending ? null : onRemoveImage,
                                  customBorder: const CircleBorder(),
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      color: AppColors.iconBackground,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 14,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : null,

              suffixIcon: Container(
                margin: const EdgeInsets.all(10),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: isSending ? null : onAttachmentPressed,
                  icon: const Icon(Icons.add, color: AppColors.primary),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: isSending ? null : onSendPressed,
            icon: isSending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(
                    CupertinoIcons.paperplane_fill,
                    color: Colors.white,
                    size: 19,
                  ),
          ),
        ),
      ],
    );
  }
}
