import 'dart:async';

import 'package:social_media_app/features/chat/data/model/new_message_user_model.dart';

abstract class NewMessageUserRemoteDataSorce {
  Stream<List<NewMessageUserModel>> getNewMessageUsers();
}
