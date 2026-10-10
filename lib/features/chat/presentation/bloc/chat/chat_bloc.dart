import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/chat/domain/usecases/get_messages.dart';
import 'package:social_media_app/features/chat/domain/usecases/send_message.dart';
import 'package:social_media_app/features/chat/presentation/bloc/chat/chat_event.dart';
import 'package:social_media_app/features/chat/presentation/bloc/chat/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase sendMessageUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  ChatBloc({required this.sendMessageUseCase, required this.getMessagesUseCase})
    : super(ChatInitial()) {
    on<SendMessage>(_sendMessage);
    on<GetMessages>(_getMessages);
  }

  Future<void> _sendMessage(SendMessage event, Emitter<ChatState> emit) async {
    try {
      await sendMessageUseCase.call(event.message);
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _getMessages(GetMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    try {
      await for (var messages in getMessagesUseCase.call(event.chatId)) {
        emit(ChatLoaded(messages));
      }
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }
}
