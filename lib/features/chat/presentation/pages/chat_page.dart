import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/widgets/app_snack_bar.dart';
import 'package:social_media_app/features/chat/domain/entities/message.dart';
import 'package:social_media_app/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:social_media_app/features/chat/presentation/bloc/chat/chat_event.dart';
import 'package:social_media_app/features/chat/presentation/bloc/chat/chat_state.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/chat_user_header.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/document_upload_bottom_sheet.dart';
import 'package:social_media_app/core/widgets/empty_state_message.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/message_bubble.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/message_input_bar.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String otherUserId;
  final String displayName;
  final String? image;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.otherUserId,
    required this.displayName,
    this.image,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();

  Uint8List? selectedImage;
  String? selectedImageName;

  bool _awaitingSendResult = false;
  bool _observedSending = false;

  final FocusNode _messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(GetMessages(chatId: widget.chatId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void sendMessage() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      AppSnackBar.showError(context, 'Please sign in to send a message.');
      return;
    }

    if (_awaitingSendResult) return;

    final text = _messageController.text.trim();

    if (text.isEmpty && selectedImage == null) return;

    _messageFocusNode.requestFocus();

    _awaitingSendResult = true;
    _observedSending = false;

    context.read<ChatBloc>().add(
      SendMessage(
        message: Message(
          senderId: currentUser.uid,
          receiverId: widget.otherUserId,
          text: text,
          image: null,
          timestamp: DateTime.now(),
        ),
        imageBytes: selectedImage,
        imageName: selectedImageName,
      ),
    );
  }

  Future<void> openAttachmentBottomSheet() async {
    if (_awaitingSendResult) return;

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
      selectedImageName = result.name;
    });
  }

  void _handleChatState(ChatState state) {
    if (state is ChatFailure) {
      AppSnackBar.showError(context, state.errorMessage);
      return;
    }
    if (state is! ChatLoaded) return;
    if (state.isSending) {
      _observedSending = true;
      return;
    }

    if (!_awaitingSendResult || !_observedSending) return;

    _awaitingSendResult = false;
    _observedSending = false;

    if (state.sendError != null) {
      AppSnackBar.showError(context, state.sendError!);
      return;
    }

    _messageController.clear();

    setState(() {
      selectedImage = null;
      selectedImageName = null;
    });

    _messageFocusNode.requestFocus();
  }

  void removeSelectedImage() {
    if (_awaitingSendResult) return;

    setState(() {
      selectedImage = null;
      selectedImageName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ChatUserHeader(
          userImage: widget.image,
          displayName: widget.displayName,
          username: 'nourasharif',
          isActive: true,
        ),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          _handleChatState(state);
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
                          ? const EmptyStateMessage(
                              message: 'No messages yet. Say hello! 👋',
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
                controller: _messageController,
                selectedImage: selectedImage,
                isSending: state is ChatLoaded && state.isSending,
                focusNode: _messageFocusNode,
                onAttachmentPressed: openAttachmentBottomSheet,
                onRemoveImage: removeSelectedImage,
                onSendPressed: sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
