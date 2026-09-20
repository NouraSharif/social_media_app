import 'package:social_media_app/features/post_details/domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.postId,
    required super.userName,
    super.userAvatarUrl,
    super.imageUrl,
    super.isDeactivated,
    required super.timeAgo,
    required super.content,
     super.likesCount,
    super.isLiked
  });

  factory CommentModel.fromEntity(CommentEntity e) => CommentModel(
    id: e.id,
    postId: e.postId,
    userName: e.userName,
    userAvatarUrl: e.userAvatarUrl,
    isDeactivated: e.isDeactivated,
    timeAgo: e.timeAgo,
    content: e.content,
    imageUrl: e.imageUrl,
    likesCount: e.likesCount,
    isLiked: e.isLiked
  );

}