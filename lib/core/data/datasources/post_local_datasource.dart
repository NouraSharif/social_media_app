import 'package:social_media_app/core/data/models/post_model.dart';
import 'package:social_media_app/core/error/exceptions.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getPosts();
  Future<PostModel> getPostById(String postId);
  Future<PostModel> updatePost(PostModel post);
  Future<PostModel> addPost(PostModel post);

}

class PostLocalDatasourceImpl implements PostLocalDataSource{

  final List<PostModel> _posts = [
    const PostModel(
        id: '1',
        userName: 'Roaa Khaled',
        timeAgo: '32 min ago',
        content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
        likesCount: 1200,
        imageUrl: 'https://i.pravatar.cc/150?img=32',
        commentsCount: 900,
        repostsCount: 1500),
    const PostModel(
        id: '2',
        userName: 'Arwa Khaled',
        timeAgo: '2 min ago',
        content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
        likesCount: 500,
        commentsCount: 200,
        isDeactivated: true,
        repostsCount: 15),
    const PostModel(
        id: '3',
        userName: 'Alaa Khaled',
        timeAgo: '2 min ago',
        userAvatarUrl: 'https://i.pravatar.cc/150?img=32',
        content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
        likesCount: 101,
        commentsCount: 850,
        isDeactivated: true,
        repostsCount: 15),
  ];



  @override
  Future<List<PostModel>> getPosts() async {
   await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable( _posts);
  }
  @override
  Future<PostModel> getPostById(String id) async{
    await Future.delayed(const Duration(milliseconds: 200));
     for(final post in _posts){
      if(post.id == id) return post;}
     throw PostNotFoundException(id);

  }
  @override
  Future<PostModel> updatePost(PostModel updated) async{
   final index = _posts.indexWhere((post) => post.id == updated.id);
   if(index == -1) throw PostNotFoundException(updated.id);
   _posts[index] = updated;
   return updated;
  }

  @override
  Future<PostModel> addPost(PostModel post) async{
    _posts.insert(0, post);
    return post;
  }

}