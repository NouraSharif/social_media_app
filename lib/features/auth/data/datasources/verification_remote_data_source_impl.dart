import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/auth/data/datasources/verification_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VerificationRemoteDataSourceImpl implements VerificationRemoteDataSource {
  final SupabaseClient supabase;
  final FirebaseAuth firebaseAuth;

  VerificationRemoteDataSourceImpl(this.supabase, this.firebaseAuth);

  @override
  Future<void> uploadVerificationDocuments({
    required String verificationType,
    required File imageFront,
    required File imageBack,
  }) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final uid = user.uid;

    final frontPath = '$uid/$verificationType/front.jpg';
    final backPath = '$uid/$verificationType/back.jpg';

    // Convert images to bytes
    final frontBytes = await imageFront.readAsBytes();
    final backBytes = await imageBack.readAsBytes();

    // Upload front image
    await supabase.storage
        .from('verification-documents')
        .uploadBinary(
          frontPath,
          frontBytes,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );

    // Upload back image
    await supabase.storage
        .from('verification-documents')
        .uploadBinary(
          backPath,
          backBytes,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );
  }
}
