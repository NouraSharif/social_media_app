import 'package:social_media_app/features/chat/domain/repository/chat_repository.dart';

class GetOrCreateChatUseCase {
  final ChatRepository repository;
  const GetOrCreateChatUseCase(this.repository);

  Future<String> call(String otherUserId) {
    return repository.getOrCreateChat(otherUserId);
  }
}
