import 'package:equatable/equatable.dart';
import 'package:social_media_app/features/chat/domain/entities/message.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class SendMessage extends ChatEvent {
  final Message message;
  const SendMessage({required this.message});

  @override
  List<Object?> get props => [message];
}

class GetMessages extends ChatEvent {
  final String chatId;
  const GetMessages({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}
