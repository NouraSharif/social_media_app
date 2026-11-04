import 'package:social_media_app/features/post_details/domain/entities/comment_entity.dart';
import 'package:social_media_app/features/post_details/domain/repositories/comment_repository.dart';

class ToggleCommentLikeUseCase {
  final CommentRepository repository;
  const ToggleCommentLikeUseCase(this.repository);
  Future<CommentEntity> call(CommentEntity comment) => repository.toggleLike(comment);
}