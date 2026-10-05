import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/exceptions.dart';
import '../models/comment_model.dart';

class CommentRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  const CommentRemoteDataSource(this.firestore, this.auth);

  Future<List<CommentModel>> getCommentsByPostId(String postId) async {
    final snapshot = await firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => CommentModel.fromMap(doc.id, postId, doc.data()))
        .toList();
  }

  Future<CommentModel> addComment(CommentModel comment) async {
    final user = auth.currentUser;
    if (user == null) throw StateError('Please sign in to comment.');
    final content = comment.content.trim();
    if (content.isEmpty || content.length > 2000) {
      throw ArgumentError('Comments must contain 1-2000 characters.');
    }
    final profile = (await firestore.collection('profiles').doc(user.uid).get())
        .data();
    final name = [
      profile?['displayName'],
      profile?['username'],
      user.displayName,
      'User',
    ].whereType<String>().firstWhere((value) => value.trim().isNotEmpty).trim();
    final photo = profile?['profileImageUrl'] as String?;
    final postRef = firestore.collection('posts').doc(comment.postId);
    // Allocate once, outside the callback: transaction retries reuse this ID.
    final commentRef = postRef.collection('comments').doc();
    final data = <String, dynamic>{
      'authorId': user.uid,
      'userName': name,
      'userPhotoUrl': photo == null || photo.trim().isEmpty ? null : photo,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    };
    await firestore.runTransaction((transaction) async {
      final post = await transaction.get(postRef);
      final existing = await transaction.get(commentRef);
      final postData = post.data();
      if (postData == null) throw PostNotFoundException(comment.postId);
      if (existing.exists) return;
      final count = (postData['commentsCount'] as num?)?.toInt() ?? 0;
      transaction.set(commentRef, data);
      transaction.update(postRef, {
        'commentsCount': count + 1,
        'lastCommentId': commentRef.id,
      });
    });
    // The write has succeeded even if a subsequent refresh cannot reach the server.
    return CommentModel.fromMap(commentRef.id, comment.postId, {
      ...data,
      'createdAt': Timestamp.now(),
    });
  }
}
