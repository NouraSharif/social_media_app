import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/create_post_request.dart';

abstract class CreatePostRemoteDataSource {
  Future<String> createPost(CreatePostRequest request);
}

class CreatePostRemoteDataSourceImpl implements CreatePostRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final SupabaseClient supabase;
  const CreatePostRemoteDataSourceImpl(
    this.firestore,
    this.firebaseAuth,
    this.supabase,
  );

  @override
  Future<String> createPost(CreatePostRequest request) async {
    final user = firebaseAuth.currentUser;
    if (user == null) throw Exception('Please sign in before posting.');
    if (request.content.trim().isEmpty && request.imagePaths.isEmpty) {
      throw Exception('Add text or an image before posting.');
    }
    final profile = (await firestore.collection('profiles').doc(user.uid).get())
        .data();
    final names = [
      profile?['displayName'],
      profile?['username'],
      user.displayName,
      'User',
    ];
    final userName = names
        .whereType<String>()
        .firstWhere((name) => name.trim().isNotEmpty)
        .trim();
    final photo = profile?['profileImageUrl'] as String?;
    final storage = supabase.storage.from('post-images');
    final uploadedPaths = <String>[];
    final urls = <String>[];
    try {
      for (final imagePath in request.imagePaths) {
        final file = File(imagePath);
        if (await file.length() > 10 * 1024 * 1024) {
          throw Exception('Each image must be 10 MB or smaller.');
        }
        final bytes = await file.readAsBytes();
        String extension;
        String mime;
        if (bytes.length >= 3 &&
            bytes[0] == 0xff &&
            bytes[1] == 0xd8 &&
            bytes[2] == 0xff) {
          extension = 'jpg';
          mime = 'image/jpeg';
        } else if (bytes.length >= 8 &&
            bytes.take(8).join(',') == '137,80,78,71,13,10,26,10') {
          extension = 'png';
          mime = 'image/png';
        } else if (bytes.length >= 12 &&
            String.fromCharCodes(bytes.take(4)) == 'RIFF' &&
            String.fromCharCodes(bytes.sublist(8, 12)) == 'WEBP') {
          extension = 'webp';
          mime = 'image/webp';
        } else {
          throw Exception('Choose a JPEG, PNG, or WebP image.');
        }
        final path = '${user.uid}/${_uuidV4()}.$extension';
        try {
          await storage.uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(contentType: mime),
          );
        } catch (_) {
          throw Exception(
            'Image upload failed. No post was created. Please try again.',
          );
        }
        uploadedPaths.add(path);
        urls.add(storage.getPublicUrl(path));
      }
      final document = firestore.collection('posts').doc();
      await document.set({
        'authorId': user.uid,
        'userName': userName,
        'userPhotoUrl': photo == null || photo.trim().isEmpty ? null : photo,
        'content': request.content.trim(),
        'category': request.category,
        'imageUrls': urls,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return document.id;
    } catch (_) {
      if (uploadedPaths.isNotEmpty) {
        try {
          await storage.remove(uploadedPaths);
        } catch (_) {
          // Cleanup is best effort; preserve the original submission error.
        }
      }
      rethrow;
    }
  }

  String _uuidV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}
