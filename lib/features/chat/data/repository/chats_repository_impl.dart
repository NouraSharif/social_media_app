import 'package:social_media_app/features/chat/data/datasource/chats/chats_remote_data_source.dart';
import 'package:social_media_app/features/chat/domain/entities/chat.dart';
import 'package:social_media_app/features/chat/domain/repository/chats_repository.dart';

class ChatsRepositoryImpl implements ChatsRepository {
  final ChatsRemoteDataSource dataSource;

  ChatsRepositoryImpl(this.dataSource);

  @override
  Stream<List<ChatEntity>> getChats() {
    return dataSource.getChats().map(
      (chats) => chats.map((chat) => chat as ChatEntity).toList(),
    );
  }

  @override
  Future<void> deleteChat(String chatId) {
    return dataSource.deleteChat(chatId);
  }
}
