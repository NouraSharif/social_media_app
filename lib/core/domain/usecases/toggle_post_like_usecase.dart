import 'package:social_media_app/core/domain/entities/post_entity.dart';
import '../repositories/post_repository.dart';

class TogglePostLikeUseCase {
  final PostRepository repository;
  const TogglePostLikeUseCase(this.repository);
  Future<PostEntity> call(PostEntity post) => repository.toggleLike(post);
}