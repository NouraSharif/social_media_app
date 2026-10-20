import 'package:social_media_app/features/chat/data/datasource/new_message_user_remote_data_sorce.dart';
import 'package:social_media_app/features/chat/domain/entities/new_message_user.dart';
import 'package:social_media_app/features/chat/domain/repository/new_message_user_repository.dart';

class NewMessageUserRepositoryImp implements NewMessageUserRepository {
  final NewMessageUserRemoteDataSorce _dataSorce;
  const NewMessageUserRepositoryImp(this._dataSorce);

  @override
  Stream<List<NewMessageUserEntity>> getNewMessageUsers() {
    return _dataSorce.getNewMessageUsers();
  }
}
