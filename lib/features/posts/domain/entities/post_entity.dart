import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id;
  final String displayName;
  final String? userAvatarUrl;
  final bool isDeactivated;
  final String timeAgo;
  final String content;
  final String? imageUrl;
  final List<String> imageUrls;
  final String authorId;
  final String category;
  final DateTime? createdAt;
  final int likesCount;
  final int commentsCount;
  final int repostsCount;
  final bool isLiked;

  const PostEntity({
    required this.id,
    required this.displayName,
    this.userAvatarUrl,
    this.isDeactivated = false,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
    this.imageUrls = const [],
    this.authorId = '',
    this.category = 'Chasing',
    this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    required this.repostsCount,
    this.isLiked = false,
  });

  PostEntity copyWith({int? likesCount, int? commentsCount, bool? isLiked}) {
    return PostEntity(
      id: id,
      displayName: displayName,
      userAvatarUrl: userAvatarUrl,
      isDeactivated: isDeactivated,
      timeAgo: timeAgo,
      content: content,
      imageUrl: imageUrl,
      imageUrls: imageUrls,
      authorId: authorId,
      category: category,
      createdAt: createdAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      repostsCount: repostsCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [
    id,
    displayName,
    userAvatarUrl,
    isDeactivated,
    timeAgo,
    content,
    imageUrl,
    imageUrls,
    authorId,
    category,
    createdAt,
    likesCount,
    commentsCount,
    repostsCount,
    isLiked,
  ];
}
