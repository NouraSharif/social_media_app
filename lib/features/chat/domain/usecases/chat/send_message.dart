import 'package:social_media_app/features/chat/domain/entities/message.dart';
import 'package:social_media_app/features/chat/domain/repository/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  const SendMessageUseCase(this.repository);

  Future<void> call(Message message) async {
    return await repository.sendMessage(message);
  }
}
