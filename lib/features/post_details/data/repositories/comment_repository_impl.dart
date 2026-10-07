import 'package:social_media_app/features/post_details/data/datasources/comment_remote_datasource.dart';
import 'package:social_media_app/features/post_details/data/models/comment_model.dart';
import 'package:social_media_app/features/post_details/domain/entities/comment_entity.dart';
import 'package:social_media_app/features/post_details/domain/repositories/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDatasource;
  const CommentRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<CommentEntity>> getCommentsByPostId(String postId) =>
      remoteDatasource.getCommentsByPostId(postId);

  @override
  Future<CommentEntity> addComment(CommentEntity comment) =>
      remoteDatasource.addComment(CommentModel.fromEntity(comment));

  @override
  Future<CommentEntity> toggleLike(CommentEntity comment) {
    throw UnsupportedError('Comment likes are not available.');
  }
}
