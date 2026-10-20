import 'package:social_media_app/features/chat/domain/entities/new_message_user.dart';
import 'package:social_media_app/features/chat/domain/repository/new_message_user_repository.dart';

class NewMessageUserUsecase {
  final NewMessageUserRepository _repository;
  const NewMessageUserUsecase(this._repository);

  Stream<List<NewMessageUserEntity>> call() {
    return _repository.getNewMessageUsers();
  }
}
