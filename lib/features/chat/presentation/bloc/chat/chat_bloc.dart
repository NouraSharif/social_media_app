import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/chat/domain/entities/message.dart';
import 'package:social_media_app/features/chat/domain/usecases/chat/get_messages.dart';
import 'package:social_media_app/features/chat/domain/usecases/chat/send_message.dart';
import 'package:social_media_app/features/chat/domain/usecases/chat/upload_chat_image_usecase.dart';
import 'package:social_media_app/features/chat/presentation/bloc/chat/chat_event.dart';
import 'package:social_media_app/features/chat/presentation/bloc/chat/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase sendMessageUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final UploadChatImageUseCase uploadChatImageUseCase;

  List<Message> _messages = [];
  bool _isSending = false;

  ChatBloc({
    required this.sendMessageUseCase,
    required this.getMessagesUseCase,
    required this.uploadChatImageUseCase,
  }) : super(ChatInitial()) {
    on<SendMessage>(_sendMessage);
    on<GetMessages>(_getMessages);
  }

  Future<void> _sendMessage(SendMessage event, Emitter<ChatState> emit) async {
    if (_isSending) return;

    _isSending = true;

    emit(ChatLoaded(_messages, isSending: true));

    try {
      final originalMessage = event.message;
      String? imagePath = originalMessage.image;

      if (event.imageBytes != null) {
        imagePath = await uploadChatImageUseCase.call(
          imageBytes: event.imageBytes!,
          fileName: event.imageName ?? 'image.jpg',
        );
      }

      final message = Message(
        senderId: originalMessage.senderId,
        receiverId: originalMessage.receiverId,
        text: originalMessage.text,
        image: imagePath,
        timestamp: originalMessage.timestamp,
      );
      await sendMessageUseCase.call(message);

      _isSending = false;
      emit(ChatLoaded(_messages));
    } catch (e) {
      _isSending = false;
      emit(ChatLoaded(_messages, sendError: getChatErrorMessage(e)));
    }
  }

  Future<void> _getMessages(GetMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    try {
      await for (final messages in getMessagesUseCase.call(event.chatId)) {
        _messages = messages;

        emit(ChatLoaded(_messages, isSending: _isSending));
      }
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }
}

String getChatErrorMessage(Object error) {
  final message = error.toString().toLowerCase();

  if (message.contains('socketexception') ||
      message.contains('connection reset') ||
      message.contains('failed host lookup') ||
      message.contains('unknownhostexception') ||
      message.contains('network is unreachable') ||
      message.contains('connection refused') ||
      message.contains('timed out') ||
      message.contains('timeout')) {
    return 'Connection problem. Check your internet and try again.';
  }

  if (message.contains('permission-denied') ||
      message.contains('unauthorized') ||
      message.contains('401') ||
      message.contains('403')) {
    return 'You do not have permission to send this message.';
  }

  if (message.contains('object not found') || message.contains('404')) {
    return 'The image could not be found. Please select it again.';
  }

  if (message.contains('image size must not exceed')) {
    return 'The image must not exceed 10 MB.';
  }

  if (message.contains('unsupported image format')) {
    return 'This image format is not supported.';
  }

  if (message.contains('not authenticated') ||
      message.contains('user is not authenticated')) {
    return 'Your session has expired. Please sign in again.';
  }

  return 'Unable to send your message. Please try again.';
}
