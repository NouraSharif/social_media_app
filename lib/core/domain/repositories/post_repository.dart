import 'package:social_media_app/core/domain/entities/post_entity.dart';

abstract class PostRepository {
  Future<List<PostEntity>> getPosts();
  Future<PostEntity> getPostById(String postId);
  Future<PostEntity> toggleLike(PostEntity post);
}