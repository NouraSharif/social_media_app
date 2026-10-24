import 'package:social_media_app/features/chat/domain/entities/new_message_user.dart';
import 'package:social_media_app/features/chat/domain/repository/new_message_user_repository.dart';

class NewMessageSearchUsersUsecase {
  final NewMessageUserRepository repository;
  const NewMessageSearchUsersUsecase(this.repository);

  Future<List<NewMessageUserEntity>> call(String searchText) {
    return repository.searchUsers(searchText);
  }
}
