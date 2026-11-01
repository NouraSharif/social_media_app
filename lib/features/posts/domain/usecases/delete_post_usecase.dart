import '../repositories/post_repository.dart';

class DeletePostUseCase {
  final PostRepository repository;
  const DeletePostUseCase(this.repository);

  Future<void> call(String postId) => repository.deletePost(postId);
}
