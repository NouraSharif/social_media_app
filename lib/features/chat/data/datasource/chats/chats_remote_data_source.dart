import 'package:social_media_app/features/chat/data/model/chat_model.dart';

abstract class ChatsRemoteDataSource {
  Stream<List<ChatModel>> getChats();
  Future<void> deleteChat(String chatId);
}
