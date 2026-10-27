import 'dart:typed_data';

import '../../domain/repository/chat_image_storage_repository.dart';
import '../datasource/chat/chat_image_storage_data_source.dart';

class ChatImageStorageRepositoryImpl implements ChatImageStorageRepository {
  final ChatImageStorageDataSource _dataSource;

  const ChatImageStorageRepositoryImpl(this._dataSource);

  @override
  Future<String> uploadChatImage({
    required Uint8List imageBytes,
    required String fileName,
  }) {
    return _dataSource.uploadChatImage(
      imageBytes: imageBytes,
      fileName: fileName,
    );
  }
}
