import 'package:social_media_app/features/post_details/domain/repositories/comment_repository.dart';

import '../entities/comment_entity.dart';

class GetCommentsUseCase {
  final CommentRepository repository;
  const GetCommentsUseCase(this.repository);
  Future<List<CommentEntity>> call(String postId) => repository.getCommentsByPostId(postId);
}