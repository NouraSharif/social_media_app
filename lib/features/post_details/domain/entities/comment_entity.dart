import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String id;
  final String postId;
  final String userName;
  final String? userAvatarUrl;
  final String? imageUrl;
  final bool isDeactivated;
  final String timeAgo;
  final String content;
  final int likesCount;
  final bool isLiked;

  const CommentEntity({
    required this.id,
    required this.postId,
    required this.userName,
    this.userAvatarUrl,
    this.imageUrl,
    this.isDeactivated = false,
    required this.timeAgo,
    required this.content,
     this.likesCount=0,
    this.isLiked = false,
  });

  CommentEntity copyWith({
    int? likesCount,
    bool? isLiked,
  }) {
    return CommentEntity(
      id: id,
      postId: postId,
      userName: userName,
      userAvatarUrl: userAvatarUrl,
      imageUrl: imageUrl,
      isDeactivated: isDeactivated,
      timeAgo: timeAgo,
      content: content,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [
    id,
    postId,
    userName,
    userAvatarUrl,
    imageUrl,
    isDeactivated,
    timeAgo,
    content,
    likesCount,
    isLiked
  ];

}