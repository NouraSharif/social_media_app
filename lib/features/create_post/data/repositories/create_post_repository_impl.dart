import 'package:social_media_app/core/data/datasources/post_local_datasource.dart';
import 'package:social_media_app/core/data/models/post_model.dart';
import '../../domain/entities/create_post_request.dart';
import '../../domain/repositories/create_post_repository.dart';

class CreatePostRepositoryImpl implements CreatePostRepository {
  final PostLocalDataSource postLocalDataSource;

  const CreatePostRepositoryImpl(this.postLocalDataSource);

  @override
  Future<String> createPost(CreatePostRequest request) async {
    final newPost = PostModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: 'You',
      timeAgo: 'Just now',
      content: request.content,
      imageUrl: request.imagePath,
      likesCount: 0,
      commentsCount: 0,
      repostsCount: 0,
    );

    await postLocalDataSource.addPost(newPost);
    return newPost.id;
  }
}