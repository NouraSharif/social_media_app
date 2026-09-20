import 'package:social_media_app/core/domain/entities/post_entity.dart';

class PostModel  extends PostEntity{
  const PostModel({
    required super.id,
    required super.userName,
    super.userAvatarUrl,
    super.isDeactivated,
    super.imageUrl,
    required super.timeAgo,
    required super.content,
    required super.likesCount,
    required super.commentsCount,
    required super.repostsCount,
  super.isLiked
  });

  factory PostModel.fromEntity(PostEntity e) => PostModel(
    id: e.id,
    userName: e.userName,
    userAvatarUrl: e.userAvatarUrl,
    isDeactivated: e.isDeactivated,
    timeAgo: e.timeAgo,
    content: e.content,
    imageUrl: e.imageUrl,
    likesCount: e.likesCount,
    commentsCount: e.commentsCount,
    repostsCount: e.repostsCount,
    isLiked: e.isLiked
  );
}