import 'package:social_media_app/features/create_post/domain/entities/create_post_request.dart';

abstract class CreatePostRepository {
  Future<String> createPost(CreatePostRequest request);
}