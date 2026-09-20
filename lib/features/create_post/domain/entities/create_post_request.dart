class CreatePostRequest {
  final String content;
  final String? category;
  final String? imagePath;

  const CreatePostRequest({
    required this.content,
     this.category,
    this.imagePath
});
}