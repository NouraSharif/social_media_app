import 'package:social_media_app/features/search/domain/entity/search_user.dart';
import 'package:social_media_app/features/search/domain/repository/search_users_repository.dart';

class SearchUsersUsecase {
  final SearchUsersRepository repository;
  const SearchUsersUsecase(this.repository);

  Future<List<SearchUserEntity>> call(String searchText) {
    return repository.searchUsers(searchText);
  }
}
