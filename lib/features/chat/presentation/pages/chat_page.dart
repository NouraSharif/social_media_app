import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/chat_user_header.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/document_upload_bottom_sheet.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/message_bubble.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/message_input_bar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.userImage,
    required this.displayName,
    required this.username,
    required this.messageText,
    required this.messageTime,
    required this.isActive,
    required this.currentUser,
  });

  final String? userImage;
  final String displayName;
  final String username;
  final String messageText;
  final String messageTime;
  final bool isActive;
  final bool currentUser;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();

  Uint8List? selectedImage;

  final List<MessageBubble> messages = [];

  @override
  void initState() {
    super.initState();

    messages.add(
      MessageBubble(
        isCurrentUser: widget.currentUser,
        messageText: widget.messageText,
        messageTime: widget.messageTime,
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> openAttachmentBottomSheet() async {
    final XFile? result = await showModalBottomSheet<XFile>(
      context: context,
      builder: (context) {
        return const DocumentUploadBottomSheet();
      },
    );

    if (result == null) return;

    final Uint8List bytes = await result.readAsBytes();

    if (!mounted) return;

    setState(() {
      selectedImage = bytes;
    });
  }

  void sendMessage() {
    final String message = messageController.text.trim();

    if (message.isEmpty && selectedImage == null) {
      return;
    }

    setState(() {
      messages.add(
        MessageBubble(
          isCurrentUser: true,
          messageText: message,
          messageTime: '10:45 AM',
          image: selectedImage,
        ),
      );

      messageController.clear();
      selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ChatUserHeader(
          userImage: widget.userImage,
          displayName: widget.displayName,
          username: widget.username,
          isActive: widget.isActive,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, i) {
                  return messages[i];
                },
              ),
            ),
          ),

          Container(
            height: 80,
            color: AppColors.white,
            padding: const EdgeInsets.all(10),
            child: MessageInputBar(
              controller: messageController,
              selectedImage: selectedImage,
              onAttachmentPressed: openAttachmentBottomSheet,
              onSendPressed: sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
