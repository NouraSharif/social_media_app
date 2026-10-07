import 'package:social_media_app/features/post_details/domain/entities/comment_entity.dart';
import 'package:social_media_app/features/post_details/domain/repositories/comment_repository.dart';

class AddCommentUseCase {

  final CommentRepository repository;
  const AddCommentUseCase(this.repository);
  Future<CommentEntity> call(CommentEntity comment) => repository.addComment(comment);

}