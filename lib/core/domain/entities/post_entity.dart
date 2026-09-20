import 'package:equatable/equatable.dart';

class PostEntity  extends Equatable{
  final String id;
  final String userName;
  final String? userAvatarUrl;
  final bool isDeactivated;
  final String timeAgo;
  final String content;
  final String? imageUrl;
  final int likesCount;
  final int commentsCount;
  final int repostsCount;
  final bool isLiked;

  const PostEntity ({
    required this.id,
    required this.userName,
    this.userAvatarUrl,
    this.isDeactivated=false,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
    required this.likesCount,
    required this.commentsCount,
    required this.repostsCount,
     this.isLiked=false});

  PostEntity copyWith({
    int? likesCount,
    bool? isLiked,
  }) {
    return PostEntity(
      id: id ,
      userName: userName,
      userAvatarUrl: userAvatarUrl ,
      isDeactivated: isDeactivated,
      timeAgo: timeAgo ,
      content: content ,
      imageUrl: imageUrl,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ,
      repostsCount: repostsCount ,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userName,
    userAvatarUrl,
    isDeactivated,
    timeAgo,
    content,
    imageUrl,
    likesCount,
    commentsCount,
    repostsCount,
    isLiked
  ];
}