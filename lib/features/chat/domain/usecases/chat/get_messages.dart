import 'package:social_media_app/features/chat/domain/entities/message.dart';
import 'package:social_media_app/features/chat/domain/repository/chat_repository.dart';

class GetMessagesUseCase {
  final ChatRepository repository;

  const GetMessagesUseCase(this.repository);

  Stream<List<Message>> call(String chatId) {
    return repository.getMessages(chatId);
  }
}
