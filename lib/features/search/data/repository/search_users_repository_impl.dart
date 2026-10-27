import 'package:social_media_app/features/search/data/datasource/search_users_remote_data_source.dart';
import 'package:social_media_app/features/search/domain/entity/search_user.dart';
import 'package:social_media_app/features/search/domain/repository/search_users_repository.dart';

class SearchUsersRepositoryImpl implements SearchUsersRepository {
  final SearchUsersRemoteDataSource dataSource;
  const SearchUsersRepositoryImpl(this.dataSource);

  @override
  Future<List<SearchUserEntity>> searchUsers(String searchText) {
    return dataSource.searchUsers(searchText);
  }
}
