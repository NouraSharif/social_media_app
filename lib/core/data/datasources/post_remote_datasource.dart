import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/post_model.dart';
import '../../error/exceptions.dart';

class PostRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final SupabaseClient supabase;
  const PostRemoteDataSource(this.firestore, this.auth, this.supabase);

  Future<void> deletePost(String postId) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw StateError('Please sign in to delete posts.');
    final postRef = firestore.collection('posts').doc(postId);
    final data = await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(postRef);
      final data = snapshot.data();
      if (data == null) throw PostNotFoundException(postId);
      if (data['authorId'] != uid) {
        throw StateError('Only the author can delete this post.');
      }
      transaction.delete(postRef);
      return data;
    });

    // Parent deletion deliberately leaves likes/comments for admin cleanup.
    // Storage cleanup must never turn a committed deletion into a failure.
    try {
      final storage = supabase.storage.from('post-images');
      final base = Uri.parse(storage.getPublicUrl(''));
      final urls = <String>{
        ...?((data['imageUrls'] as List?)?.whereType<String>()),
        if (data['imageUrl'] is String) data['imageUrl'] as String,
      };
      final paths = <String>{};
      for (final url in urls) {
        final uri = Uri.tryParse(url);
        if (uri == null ||
            (uri.scheme != 'https' && uri.scheme != 'http') ||
            !uri.hasAuthority ||
            uri.origin != base.origin ||
            !uri.path.startsWith(base.path)) {
          continue;
        }
        final path = Uri.decodeComponent(uri.path.substring(base.path.length));
        final segments = path.split('/');
        if (segments.length < 2 ||
            segments.first != uid ||
            segments.any(
              (part) => part.isEmpty || part == '.' || part == '..',
            )) {
          continue;
        }
        paths.add(path);
      }
      if (paths.isNotEmpty) {
        await storage
            .remove(paths.toList())
            .timeout(const Duration(seconds: 10));
      }
    } catch (_) {
      // Best effort: the post is already deleted even if images remain.
    }
  }

  Future<PostModel> _mapPost(
    DocumentSnapshot<Map<String, dynamic>> doc,
    String? uid,
  ) async {
    final data = doc.data();
    if (data == null) throw PostNotFoundException(doc.id);
    final liked =
        uid != null &&
        (await doc.reference.collection('likes').doc(uid).get()).exists;
    return PostModel.fromMap(doc.id, data, isLiked: liked);
  }

  Future<List<PostModel>> getPosts() async {
    final uid = auth.currentUser?.uid;
    final snapshot = await firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .get();
    return Future.wait(snapshot.docs.map((doc) => _mapPost(doc, uid)));
  }

  Future<PostModel> getPostById(String id) async {
    final uid = auth.currentUser?.uid;
    final doc = await firestore.collection('posts').doc(id).get();
    return _mapPost(doc, uid);
  }

  Future<PostModel> toggleLike(String postId) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw StateError('Please sign in to like posts.');
    final postRef = firestore.collection('posts').doc(postId);
    final likeRef = postRef.collection('likes').doc(uid);
    return firestore.runTransaction<PostModel>((transaction) async {
      final post = await transaction.get(postRef);
      final like = await transaction.get(likeRef);
      final data = post.data();
      if (data == null) throw PostNotFoundException(postId);
      final count = (data['likesCount'] as num?)?.toInt() ?? 0;
      final nextCount = count + (like.exists ? -1 : 1);
      if (nextCount < 0) throw StateError('Invalid like count.');
      if (like.exists) {
        transaction.delete(likeRef);
      } else {
        transaction.set(likeRef, {'createdAt': FieldValue.serverTimestamp()});
      }
      transaction.update(postRef, {'likesCount': nextCount});
      return PostModel.fromMap(postId, {
        ...data,
        'likesCount': nextCount,
      }, isLiked: !like.exists);
    });
  }
}
