import 'dart:io';

abstract class VerificationRepository {
  Future<void> uploadVerificationDocuments({
    required String verificationType,
    required File imageFront,
    required File imageBack,
  });
}
