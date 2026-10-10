import 'package:social_media_app/features/chat/data/datasource/chat_remote_data_source.dart';
import 'package:social_media_app/features/chat/domain/entities/message.dart';
import 'package:social_media_app/features/chat/domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource dataSource;
  const ChatRepositoryImpl(this.dataSource);

  @override
  Future<void> sendMessage(Message message) {
    return dataSource.sendMessage(message);
  }

  @override
  Stream<List<Message>> getMessages(String chatId) {
    return dataSource.getMessages(chatId);
  }
}
