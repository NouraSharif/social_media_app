import 'dart:io';

import 'package:social_media_app/features/auth/domain/repositories/verification_repository.dart';

class VerificationUseCase {
  final VerificationRepository repository;

  VerificationUseCase(this.repository);

  Future<void> call({
    required String verificationType,
    required File imageFront,
    required File imageBack,
  }) {
    return repository.uploadVerificationDocuments(
      verificationType: verificationType,
      imageFront: imageFront,
      imageBack: imageBack,
    );
  }
}
