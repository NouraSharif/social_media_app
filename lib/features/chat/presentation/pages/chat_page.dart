import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/widgets/app_snack_bar.dart';
import 'package:social_media_app/features/chat/domain/entities/message.dart';
import 'package:social_media_app/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:social_media_app/features/chat/presentation/bloc/chat/chat_event.dart';
import 'package:social_media_app/features/chat/presentation/bloc/chat/chat_state.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/chat_user_header.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/document_upload_bottom_sheet.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/message_bubble.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/message_input_bar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    // required this.chatId,
    // required this.displayName,
    // required this.username,
    // required this.currentUser,
    // required this.receiverId,
    // required this.userImage,
    // required this.isActive,
  });
  //final String chatId;
  // final String displayName;
  // final String username;
  // final bool currentUser;
  // final String receiverId;
  // final String userImage;
  // final bool isActive;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageController = TextEditingController();
  Uint8List? selectedImage;

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(GetMessages(chatId: '1'));
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void sendMessage() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      AppSnackBar.showError(context, 'Please sign in to send a message.');
      return;
    }
    final currentUserId = currentUser.uid;

    final text = messageController.text.trim();
    if (text.isEmpty) return;

    context.read<ChatBloc>().add(
      SendMessage(
        message: Message(
          senderId: currentUserId,
          receiverId: 'srAojhGTrvN3c7BQM93FQtFtkaV2',
          text: text,
          image: null,
          timestamp: DateTime.now(),
        ),
      ),
    );
    messageController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ChatUserHeader(
          userImage: null,
          displayName: 'Noura Hassanin',
          username: 'nourasharif',
          isActive: true,
        ),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatFailure) {
            debugPrint('CHAT ERROR: ${state.errorMessage}');
            AppSnackBar.showError(context, state.errorMessage);
          }
        },
        builder: (context, state) => Column(
          children: [
            Expanded(
              child: state is ChatLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state is ChatLoaded
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: state.messages.isEmpty
                          ? Center(
                              child: Text(
                                'No messages yet. Say hello! 👋',
                                style: AppTextStyles.body,
                              ),
                            )
                          : ListView.builder(
                              reverse: true,
                              itemCount: state.messages.length,
                              itemBuilder: (context, i) {
                                final message = state.messages[i];

                                return MessageBubble(
                                  isCurrentUser:
                                      message.senderId ==
                                      FirebaseAuth.instance.currentUser?.uid,
                                  messageText: message.text,
                                  messageTime:
                                      message.timestamp ?? DateTime.now(),
                                  image: message.image,
                                );
                              },
                            ),
                    )
                  : const SizedBox.expand(),
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
      ),
    );
  }
}
