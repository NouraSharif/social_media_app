import 'package:equatable/equatable.dart';
import 'package:social_media_app/features/chat/domain/entities/chat.dart';

sealed class ChatsState extends Equatable {
  const ChatsState();
  @override
  List<Object?> get props => [];
}

class ChatsInitial extends ChatsState {}

class ChatsLoading extends ChatsState {}

class ChatsLoaded extends ChatsState {
  final List<ChatEntity> chats;
  const ChatsLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

class ChatsFailure extends ChatsState {
  final String message;
  const ChatsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
