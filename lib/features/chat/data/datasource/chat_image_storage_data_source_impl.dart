import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'chat_image_storage_data_source.dart';

class ChatImageStorageDataSourceImpl implements ChatImageStorageDataSource {
  final SupabaseClient _supabase;
  final FirebaseAuth _auth;

  const ChatImageStorageDataSourceImpl(this._supabase, this._auth);

  static const String _bucketName = 'chat-images';
  static const int _maxFileSize = 10 * 1024 * 1024;
  static const Duration _uploadTimeout = Duration(seconds: 90);
  static const int _signedUrlExpirySeconds = 60 * 60 * 24;

  @override
  Future<String> uploadChatImage({
    required Uint8List imageBytes,
    required String fileName,
  }) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw Exception('User is not authenticated.');
    }

    if (imageBytes.isEmpty) {
      throw Exception('Image file is empty.');
    }

    if (imageBytes.length > _maxFileSize) {
      throw Exception('Image size must not exceed 10 MB.');
    }

    final dotIndex = fileName.lastIndexOf('.');
    final extension = dotIndex == -1
        ? ''
        : fileName.substring(dotIndex + 1).toLowerCase();

    const contentTypes = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'webp': 'image/webp',
    };

    final contentType = contentTypes[extension];

    if (contentType == null) {
      throw Exception('Unsupported image format: $extension');
    }

    final filePath =
        '${currentUser.uid}/'
        '${DateTime.now().microsecondsSinceEpoch}.$extension';

    await _supabase.storage
        .from(_bucketName)
        .uploadBinary(
          filePath,
          imageBytes,
          fileOptions: FileOptions(contentType: contentType, upsert: false),
        )
        .timeout(_uploadTimeout);

    return _supabase.storage
        .from(_bucketName)
        .createSignedUrl(filePath, _signedUrlExpirySeconds);
  }
}
