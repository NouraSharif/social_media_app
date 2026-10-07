import 'package:equatable/equatable.dart';
import 'package:social_media_app/core/domain/entities/post_entity.dart';
import 'package:social_media_app/features/post_details/domain/entities/comment_entity.dart';

enum PostDetailsStatus { initial, loading, success, notFound, failure }

class PostDetailsState extends Equatable {
  final PostDetailsStatus status;
  final PostEntity? post;
  final List<CommentEntity> comments;
  final String? errorMessage;
  final bool isLiking;
  final bool isSubmitting;
  final int submittedCount;

  const PostDetailsState({
    this.status = PostDetailsStatus.initial,
    this.post,
    this.comments = const [],
    this.errorMessage,
    this.isLiking = false,
    this.isSubmitting = false,
    this.submittedCount = 0,
  });

  PostDetailsState copyWith({
    PostDetailsStatus? status,
    PostEntity? post,
    List<CommentEntity>? comments,
    String? errorMessage,
    bool? isLiking,
    bool? isSubmitting,
    int? submittedCount,
  }) => PostDetailsState(
    status: status ?? this.status,
    post: post ?? this.post,
    comments: comments ?? this.comments,
    errorMessage: errorMessage,
    isLiking: isLiking ?? this.isLiking,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    submittedCount: submittedCount ?? this.submittedCount,
  );

  @override
  List<Object?> get props => [
    status,
    post,
    comments,
    errorMessage,
    isLiking,
    isSubmitting,
    submittedCount,
  ];
}
