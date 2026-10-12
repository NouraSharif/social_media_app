import 'dart:typed_data';

abstract class ChatImageStorageRepository {
  Future<String> uploadChatImage({
    required Uint8List imageBytes,
    required String fileName,
  });
}
