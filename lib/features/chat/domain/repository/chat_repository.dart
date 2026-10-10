import 'package:social_media_app/features/chat/domain/entities/message.dart';

abstract class ChatRepository {
  Future<void> sendMessage(Message message);
  Stream<List<Message>> getMessages(String chatId);
}
