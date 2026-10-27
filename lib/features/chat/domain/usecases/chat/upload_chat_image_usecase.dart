import 'dart:typed_data';

import '../../../domain/repository/chat_image_storage_repository.dart';

class UploadChatImageUseCase {
  final ChatImageStorageRepository _repository;

  const UploadChatImageUseCase(this._repository);

  Future<String> call({
    required Uint8List imageBytes,
    required String fileName,
  }) {
    return _repository.uploadChatImage(
      imageBytes: imageBytes,
      fileName: fileName,
    );
  }
}
