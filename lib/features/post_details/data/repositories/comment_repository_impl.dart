import 'package:social_media_app/features/post_details/data/datasources/comment_local_datasource.dart';
import 'package:social_media_app/features/post_details/data/models/comment_model.dart';
import 'package:social_media_app/features/post_details/domain/entities/comment_entity.dart';
import 'package:social_media_app/features/post_details/domain/repositories/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {

  final CommentLocalDatasource localDatasource;
  const CommentRepositoryImpl(this.localDatasource);

  @override
  Future<List<CommentEntity>> getCommentsByPostId(String postId) =>
    localDatasource.getCommentsByPostId(postId);


  @override
  Future<CommentEntity> addComment(CommentEntity comment) =>
      localDatasource.addComment(CommentModel.fromEntity(comment));


  @override
  Future<CommentEntity> toggleLike(CommentEntity comment) {
    final newIsLiked = !comment.isLiked;
    final updated = comment.copyWith(
      isLiked: newIsLiked,
      likesCount: newIsLiked ? comment.likesCount + 1 : comment.likesCount - 1,
    );
    return localDatasource.updateComment(CommentModel.fromEntity(updated));
  }
}