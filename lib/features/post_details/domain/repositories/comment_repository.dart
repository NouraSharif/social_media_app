import 'package:social_media_app/features/post_details/domain/entities/comment_entity.dart';

abstract class CommentRepository {

  Future<List<CommentEntity>> getCommentsByPostId(String postId);
  Future<CommentEntity> addComment(CommentEntity comment);
  Future<CommentEntity> toggleLike(CommentEntity comment);

}