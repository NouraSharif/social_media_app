import 'package:equatable/equatable.dart';
import 'package:social_media_app/features/chat/domain/entities/message.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messages;
  const ChatLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatFailure extends ChatState {
  final String errorMessage;
  const ChatFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
