import 'dart:io';

import 'package:social_media_app/features/auth/data/datasources/verification_remote_data_source.dart';
import 'package:social_media_app/features/auth/domain/repositories/verification_repository.dart';

class VerificationRepositoryImpl implements VerificationRepository {
  final VerificationRemoteDataSource remoteDataSource;
  VerificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> uploadVerificationDocuments({
    required String verificationType,
    required File imageFront,
    required File imageBack,
  }) {
    return remoteDataSource.uploadVerificationDocuments(
      verificationType: verificationType,
      imageFront: imageFront,
      imageBack: imageBack,
    );
  }
}
