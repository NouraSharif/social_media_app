import 'package:social_media_app/features/posts/domain/entities/post_entity.dart';
import 'package:social_media_app/features/posts/domain/repositories/post_repository.dart';

class GetPostsUseCase {
  final PostRepository repository;
  const GetPostsUseCase( this.repository);
  Future<List<PostEntity>> call() => repository.getPosts();
}