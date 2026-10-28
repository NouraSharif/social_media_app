import 'package:social_media_app/core/domain/entities/post_entity.dart';
import 'package:social_media_app/core/domain/repositories/post_repository.dart';

class GetPostsUseCase {
  final PostRepository repository;
  const GetPostsUseCase( this.repository);
  Future<List<PostEntity>> call() => repository.getPosts();
}