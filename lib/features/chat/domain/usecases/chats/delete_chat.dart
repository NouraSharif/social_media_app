import 'package:social_media_app/features/chat/domain/repository/chats_repository.dart';

class DeleteChatUseCase {
  final ChatsRepository _chatsRepository;
  const DeleteChatUseCase(this._chatsRepository);

  Future<void> call(String chatId) {
    return _chatsRepository.deleteChat(chatId);
  }
}
