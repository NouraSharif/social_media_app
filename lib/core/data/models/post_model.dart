import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/core/domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.userName,
    super.userAvatarUrl,
    super.isDeactivated,
    super.imageUrl,
    super.imageUrls,
    super.authorId,
    super.category,
    super.createdAt,
    required super.timeAgo,
    required super.content,
    required super.likesCount,
    required super.commentsCount,
    required super.repostsCount,
    super.isLiked,
  });

  factory PostModel.fromEntity(PostEntity e) => PostModel(
    id: e.id,
    userName: e.userName,
    userAvatarUrl: e.userAvatarUrl,
    isDeactivated: e.isDeactivated,
    timeAgo: e.timeAgo,
    content: e.content,
    imageUrl: e.imageUrl,
    imageUrls: e.imageUrls,
    authorId: e.authorId,
    category: e.category,
    createdAt: e.createdAt,
    likesCount: e.likesCount,
    commentsCount: e.commentsCount,
    repostsCount: e.repostsCount,
    isLiked: e.isLiked,
  );
  factory PostModel.fromMap(
    String id,
    Map<String, dynamic> data, {
    bool isLiked = false,
  }) {
    final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
    final images = List<String>.unmodifiable(
      (data['imageUrls'] as List<dynamic>? ?? []).cast<String>(),
    );
    final age = createdAt == null
        ? Duration.zero
        : DateTime.now().difference(createdAt);
    final timeAgo = age.inMinutes < 1
        ? 'Just now'
        : age.inHours < 1
        ? '${age.inMinutes} min ago'
        : age.inDays < 1
        ? '${age.inHours} hr ago'
        : '${age.inDays} days ago';
    return PostModel(
      id: id,
      authorId: data['authorId'] as String? ?? '',
      userName: data['userName'] as String? ?? 'User',
      userAvatarUrl: data['userPhotoUrl'] as String?,
      content: data['content'] as String? ?? '',
      category: data['category'] as String? ?? 'Chasing',
      imageUrls: images,
      createdAt: createdAt,
      timeAgo: timeAgo,
      likesCount: (data['likesCount'] as num?)?.toInt() ?? 0,
      commentsCount: (data['commentsCount'] as num?)?.toInt() ?? 0,
      isLiked: isLiked,
      repostsCount: 0,
    );
  }
}
