class   Comment {
  final String id;
  final String postId;
  final String userName;
  final String? userAvatarUrl;
  final String? imageUrl;

  final String content;
  final bool isDeactivated;
  final String timeAgo;
  int likesCount;
  bool isLiked;

  Comment({
    required this.id,
    required this.postId,
    required this.userName,
    this.userAvatarUrl,
    this.imageUrl,
    required this.content,
     this.isDeactivated = false,
    this.likesCount = 0,
    this.isLiked = false,
    required this.timeAgo});
}

/// Dummy data
List<Comment> mockComments = [
  Comment(
    id: 'c1',
    postId: '1',
    userName: 'Sarah Ahmad',
    userAvatarUrl: 'https://i.pravatar.cc/150?img=45',
    timeAgo: '10 mins ago',
    content: 'This is amazing! Thanks for sharing.This is amazing! Thanks for sharing.This is amazing! Thanks for sharing.This is amazing! Thanks for sharing.',
    likesCount: 24,
  ),
  Comment(
    id: 'c2',
    postId: '1',
    userName: 'Deactivated user',
    isDeactivated: true,
    timeAgo: '25 mins ago',
    content: 'Totally agree with this point.',
    likesCount: 8,
  ),
  Comment(
    id: 'c3',
    postId: '1',
    userName: 'Omar Khalil',
    userAvatarUrl: 'https://i.pravatar.cc/150?img=51',
    timeAgo: '1 hour ago',
    content: 'Can you share more details about this?',
    likesCount: 3,
  ),
];