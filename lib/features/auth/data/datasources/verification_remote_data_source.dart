import 'dart:io';

abstract class VerificationRemoteDataSource {
  Future<void> uploadVerificationDocuments({
    required String verificationType,
    required File imageFront,
    required File imageBack,
  });
}
