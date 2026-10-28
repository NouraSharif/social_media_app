import 'package:social_media_app/core/domain/entities/post_entity.dart';
import 'package:social_media_app/core/domain/repositories/post_repository.dart';

class GetPostByIdUseCase {
  final PostRepository repository;
  const GetPostByIdUseCase(this.repository);
  Future<PostEntity> call(String postId) => repository.getPostById(postId);
}