import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:social_media_app/features/chat/domain/entities/message.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class SendMessage extends ChatEvent {
  final Message message;
  final Uint8List? imageBytes;
  final String? imageName;
  const SendMessage({required this.message, this.imageBytes, this.imageName});

  @override
  List<Object?> get props => [message, imageBytes, imageName];
}

class GetMessages extends ChatEvent {
  final String chatId;
  const GetMessages({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}
