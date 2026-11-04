import '../datasources/create_post_remote_datasource.dart';
import '../../domain/entities/create_post_request.dart';
import '../../domain/repositories/create_post_repository.dart';

class CreatePostRepositoryImpl implements CreatePostRepository {
  final CreatePostRemoteDataSource remoteDataSource;
  const CreatePostRepositoryImpl(this.remoteDataSource);
  @override
  Future<String> createPost(CreatePostRequest request) =>
      remoteDataSource.createPost(request);
}
