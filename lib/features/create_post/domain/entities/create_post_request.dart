class CreatePostRequest {
  final String content;
  final String category;
  final List<String> imagePaths;
  const CreatePostRequest({
    required this.content,
    this.category = 'Chasing',
    this.imagePaths = const [],
  });
}
