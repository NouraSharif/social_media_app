import 'package:equatable/equatable.dart';
import 'package:social_media_app/features/chat/domain/entities/new_message_user.dart';

sealed class NewMessageUserState extends Equatable {
  const NewMessageUserState();

  @override
  List<Object?> get props => [];
}

class NewMessageUserInitial extends NewMessageUserState {}

class NewMessageUserLoading extends NewMessageUserState {}

class NewMessageUserLoaded extends NewMessageUserState {
  final List<NewMessageUserEntity> data;
  const NewMessageUserLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class NewMessageSearchUsersLoaded extends NewMessageUserState {
  final List<NewMessageUserEntity> data;
  const NewMessageSearchUsersLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class NewMessageUserFailure extends NewMessageUserState {
  final String message;
  const NewMessageUserFailure(this.message);

  @override
  List<Object?> get props => [message];
}
