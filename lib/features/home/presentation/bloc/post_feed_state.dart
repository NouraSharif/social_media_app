import 'package:equatable/equatable.dart';
import 'package:social_media_app/core/domain/entities/post_entity.dart';

enum PostFeedStatus{initial , loading , success, failure}

class PostFeedState extends Equatable{
  final PostFeedStatus status;
  final List<PostEntity> posts;
  final String? errorMessage;

  const PostFeedState({
    this.status = PostFeedStatus.initial,
    this.posts = const[],
    this.errorMessage
});

  PostFeedState copyWith({
    PostFeedStatus? status,
    List<PostEntity>? posts,
    String? errorMessage
}) {
    return PostFeedState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      errorMessage: errorMessage
    );
  }

  @override
  List<Object?> get props =>[ status , posts , errorMessage];

}