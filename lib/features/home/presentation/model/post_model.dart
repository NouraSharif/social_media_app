class Post {
  final String id;
  final String userName;
  final String? userAvatarUrl;
  final bool isDeactivated;
  final String timeAgo;
  final String content;
  final String? imageUrl;
  int likesCount;
  final int commentsCount;
  final int repostsCount;
  bool isLiked;

  Post({
    required this.id,
    required this.userName,
    this.userAvatarUrl,
    this.isDeactivated = false,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
    required this.likesCount,
    required this.commentsCount,
    required this.repostsCount,
    this.isLiked = false,
  });
}

/// Dummy data just to preview the UI. Replace with real data whenever
/// it's ready — the widgets below don't need to change.
List<Post> mockPosts = [
  Post(
    id: '1',
    userName: 'Kyle Konecny',
    userAvatarUrl: 'https://i.pravatar.cc/150?img=12',
    timeAgo: '32 mins ago',
    content:
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
    imageUrl: 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9',
    likesCount: 1200,
    commentsCount: 900,
    repostsCount: 100,
  ),
  Post(
    id: '2',
    userName: 'Deactivated user',
    isDeactivated: true,
    timeAgo: '1 hour ago',
    content:
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
    likesCount: 1200,
    commentsCount: 900,
    repostsCount: 100,
  ),
  Post(
    id: '3',
    userName: 'Lena Tsysar',
    userAvatarUrl: 'https://i.pravatar.cc/150?img=32',
    timeAgo: '4 hours ago',
    content:
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry has been the.',
    likesCount: 850,
    commentsCount: 320,
    repostsCount: 40,
  ),
];
