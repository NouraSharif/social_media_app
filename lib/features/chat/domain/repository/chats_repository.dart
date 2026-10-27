import 'package:social_media_app/features/chat/domain/entities/chat.dart';

abstract class ChatsRepository {
  Stream<List<ChatEntity>> getChats();
  Future<void> deleteChat(String chatId);
}
