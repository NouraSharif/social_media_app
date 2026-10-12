import 'dart:typed_data';

abstract class ChatImageStorageDataSource {
  Future<String> uploadChatImage({
    required Uint8List imageBytes,
    required String fileName,
  });
}
