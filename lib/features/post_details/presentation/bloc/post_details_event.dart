import 'package:equatable/equatable.dart';
import 'package:social_media_app/core/domain/entities/post_entity.dart';
import 'package:social_media_app/features/post_details/domain/entities/comment_entity.dart';

sealed class PostDetailsEvent extends Equatable {
  const PostDetailsEvent();

  @override
  List<Object?> get props => [];
}

class PostDetailsRequested extends PostDetailsEvent{
  final String postId;
  const PostDetailsRequested(this.postId);

  @override
  List<Object?> get props => [postId];
  }

  class PostDetailsPostLikeToggled extends PostDetailsEvent {

  final PostEntity post;
  const PostDetailsPostLikeToggled(this.post);

  @override
  List<Object?> get props => [post];
  }

  class PostDetailsCommentLikeToggled extends PostDetailsEvent{
    final CommentEntity comment;
    const PostDetailsCommentLikeToggled(this.comment);

    @override
  List<Object?> get props => [comment];
  }

  class PostDetailsCommentSubmitted extends PostDetailsEvent{
    final String content;
    const PostDetailsCommentSubmitted(this.content);

    @override
  List<Object?> get props => [content];
  }