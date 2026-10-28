import 'package:social_media_app/features/create_post/domain/entities/create_post_request.dart';
import 'package:social_media_app/features/create_post/domain/repositories/create_post_repository.dart';

class CreatePostUseCase {
  final CreatePostRepository repository;
  const CreatePostUseCase(this.repository);

  Future<String> call(CreatePostRequest request) => repository.createPost(request);


}