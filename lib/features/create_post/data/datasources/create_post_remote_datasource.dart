abstract class CreatePostRemoteDataSource {

  Future<String> createPost({
    required String content,
     String? category,
    String? imagePath
});

}

class CreatePostLocalDataSourceImpl implements CreatePostRemoteDataSource{

  @override
  Future<String> createPost({
    required String content,
     String? category,
    String? imagePath,
}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return DateTime.now().millisecondsSinceEpoch.toString();

  }
}