import 'package:social_media_app/features/chat/domain/entities/new_message_user.dart';

abstract class NewMessageUserRepository {
  Stream<List<NewMessageUserEntity>> getNewMessageUsers();
}
