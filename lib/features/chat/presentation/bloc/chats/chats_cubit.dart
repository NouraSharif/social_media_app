import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/chat/domain/entities/chat.dart';
import 'package:social_media_app/features/chat/domain/usecases/chats/delete_chat.dart';
import 'package:social_media_app/features/chat/domain/usecases/chats/get_chats.dart';
import 'package:social_media_app/features/chat/presentation/bloc/chats/chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final GetChatsUseCase _getChatsUseCase;
  final DeleteChatUseCase _deleteChatUseCase;
  StreamSubscription<List<ChatEntity>>? _chatsSubscription;

  ChatsCubit({
    required GetChatsUseCase getChatsUseCase,
    required this._deleteChatUseCase,
  }) : _getChatsUseCase = getChatsUseCase,
       super(ChatsInitial());

  void getChats() {
    emit(ChatsLoading());

    _chatsSubscription?.cancel();

    _chatsSubscription = _getChatsUseCase().listen(
      (chats) {
        emit(ChatsLoaded(chats));
      },
      onError: (error) {
        emit(ChatsFailure(error.toString()));
      },
    );
  }

  Future<void> deleteChat(String chatId) async {
    await _deleteChatUseCase.call(chatId);
  }

  @override
  Future<void> close() async {
    await _chatsSubscription?.cancel();
    return super.close();
  }
}
