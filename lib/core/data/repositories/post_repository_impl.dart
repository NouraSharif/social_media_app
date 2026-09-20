import 'package:social_media_app/core/data/datasources/post_local_datasource.dart';
import 'package:social_media_app/core/data/models/post_model.dart';
import 'package:social_media_app/core/domain/entities/post_entity.dart';

import '../../domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository{
  final PostLocalDataSource localDatasource;
  const PostRepositoryImpl(this.localDatasource);

  @override
  Future<PostEntity> getPostById(String postId) => localDatasource.getPostById(postId);

  @override
  Future<List<PostEntity>> getPosts() => localDatasource.getPosts();

  @override
  Future<PostEntity> toggleLike(PostEntity post) {
    final bool newIsLiked = !post.isLiked;
    final updatedEntity = post.copyWith(
        isLiked: newIsLiked,
      likesCount: newIsLiked ? post.likesCount + 1 : post.likesCount - 1,
    );
    return localDatasource.updatePost(PostModel.fromEntity(updatedEntity));
  }

}