class PostNotFoundException implements Exception {
  final String postId;
  PostNotFoundException(this.postId);

  @override
  String toString() => 'Post with id "$postId" not found';
}