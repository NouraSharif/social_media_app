import 'package:social_media_app/features/search/domain/entity/search_user.dart';

abstract class SearchUsersRepository {
  Future<List<SearchUserEntity>> searchUsers(String searchText);
}
