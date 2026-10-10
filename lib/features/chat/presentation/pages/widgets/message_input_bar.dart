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
  });

  final TextEditingController controller;
  final VoidCallback onAttachmentPressed;
  final VoidCallback onSendPressed;
  final Uint8List? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => onSendPressed(),
            onEditingComplete: () {},
            maxLines: null,
            minLines: 1,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceLight,

              hintText: 'Type your message ..',

              hintStyle: const TextStyle(color: Color(0xFF91999E)),

              prefixIcon: selectedImage != null
                  ? Padding(
                      padding: const EdgeInsets.all(6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          selectedImage!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
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
                  onPressed: onAttachmentPressed,
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
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: onSendPressed,
            icon: Icon(CupertinoIcons.paperplane_fill),
          ),
        ),
      ],
    );
  }
}
