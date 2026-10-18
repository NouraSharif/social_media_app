import 'package:social_media_app/features/chat/domain/entities/chat.dart';
import 'package:social_media_app/features/chat/domain/repository/chats_repository.dart';

class GetChatsUseCase {
  final ChatsRepository chatsRepository;
  const GetChatsUseCase(this.chatsRepository);

  Stream<List<ChatEntity>> call() {
    return chatsRepository.getChats();
  }
}
