import 'package:equatable/equatable.dart';
import 'package:social_media_app/core/domain/entities/post_entity.dart';
import 'package:social_media_app/features/post_details/domain/entities/comment_entity.dart';

enum PostDetailsStatus {initial, loading, success, notFound, failure}

class PostDetailsState extends Equatable {
  final PostDetailsStatus status;
  final PostEntity? post;
  final List<CommentEntity> comments;
  final String? errorMessage;

  const PostDetailsState({
    this.status = PostDetailsStatus.initial,
    this.post,
    this.comments= const [],
    this.errorMessage
});

  PostDetailsState copyWith({
    PostDetailsStatus? status,
    PostEntity? post,
    List<CommentEntity>? comments,
    String? errorMessage
}){
    return PostDetailsState(
      status: status ?? this.status,
      post: post ?? this.post,
      comments: comments ?? this.comments,
      errorMessage: errorMessage
    );
  }

  @override
  List<Object?> get props => [status, post, comments, errorMessage];


}