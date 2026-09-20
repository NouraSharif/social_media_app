import 'package:flutter/foundation.dart';
import 'package:social_media_app/features/post_details/data/models/comment_model.dart';

abstract class CommentLocalDatasource {
  Future<List<CommentModel>> getCommentsByPostId(String postId);
  Future<CommentModel> addComment(CommentModel comment);
  Future <CommentModel> updateComment(CommentModel comment);

}

class CommentLocalDataSourceImpl implements CommentLocalDatasource{

  final List<CommentModel> _comments = [
    const CommentModel(
        id: 'c1',
        postId: '1',
        userName: 'Barraa Alshammari',
        timeAgo: '10 min ago',
        content: 'this is a comment',
    likesCount: 5,),

    const CommentModel(
        id: 'c2',
        postId: '1',
        userName: 'John Doe',
        timeAgo: '20 min ago',
        userAvatarUrl: 'https://i.pravatar.cc/150?img=51',
        isDeactivated: true,
        content: 'this is another comment',
        likesCount: 2,),

  ];

  @override
  Future<List<CommentModel>> getCommentsByPostId(String postId) async {
   await Future.delayed(const Duration(milliseconds: 200));
    return _comments.where((c)=> c.postId == postId).toList();
  }
  
  @override
  Future<CommentModel> addComment(CommentModel comment) async{
    _comments.insert(0, comment);
    return comment;
  }

  @override
  Future<CommentModel> updateComment(CommentModel updated) async {
    final index = _comments.indexWhere((c) => c.id == updated.id);
    if(index != -1) _comments[index] = updated;
    return updated;
  }

}