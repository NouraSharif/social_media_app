import '../datasources/post_remote_datasource.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDatasource;
  const PostRepositoryImpl(this.remoteDatasource);
  @override
  Future<PostEntity> getPostById(String postId) =>
      remoteDatasource.getPostById(postId);
  @override
  Future<List<PostEntity>> getPosts() => remoteDatasource.getPosts();
  @override
  Future<PostEntity> toggleLike(PostEntity post) async {
    return remoteDatasource.toggleLike(post.id);
  }
}
