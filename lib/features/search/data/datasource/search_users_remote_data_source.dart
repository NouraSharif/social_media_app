import 'package:social_media_app/features/search/data/model/search_user_model.dart';

abstract class SearchUsersRemoteDataSource {
  Future<List<SearchUserModel>> searchUsers(String searchText);
}
