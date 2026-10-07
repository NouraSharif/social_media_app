import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/post_details/domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    super.authorId,
    super.createdAt,
    required super.id,
    required super.postId,
    required super.userName,
    super.userAvatarUrl,
    super.imageUrl,
    super.isDeactivated,
    required super.timeAgo,
    required super.content,
    super.likesCount,
    super.isLiked,
  });

  factory CommentModel.fromEntity(CommentEntity e) => CommentModel(
    authorId: e.authorId,
    createdAt: e.createdAt,
    id: e.id,
    postId: e.postId,
    userName: e.userName,
    userAvatarUrl: e.userAvatarUrl,
    isDeactivated: e.isDeactivated,
    timeAgo: e.timeAgo,
    content: e.content,
    imageUrl: e.imageUrl,
    likesCount: e.likesCount,
    isLiked: e.isLiked,
  );

  factory CommentModel.fromMap(
    String id,
    String postId,
    Map<String, dynamic> data,
  ) {
    final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
    final age = createdAt == null
        ? Duration.zero
        : DateTime.now().difference(createdAt);
    return CommentModel(
      id: id,
      postId: postId,
      authorId: data['authorId'] as String,
      createdAt: createdAt,
      userName: data['userName'] as String? ?? 'User',
      userAvatarUrl: data['userPhotoUrl'] as String?,
      content: data['content'] as String,
      timeAgo: age.inMinutes < 1
          ? 'Just now'
          : age.inHours < 1
          ? '${age.inMinutes} min ago'
          : age.inDays < 1
          ? '${age.inHours} hr ago'
          : '${age.inDays} days ago',
    );
  }
}
