import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/profile/data/datasource/profile_remote_data_source.dart';
import 'package:social_media_app/features/profile/data/model/profile_model.dart';
import 'package:social_media_app/features/profile/domain/entities/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final SupabaseClient supabase;
  ProfileRemoteDataSourceImpl(this.firestore, this.firebaseAuth, this.supabase);
  @override
  Future<void> saveProfile({required Profile profile}) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }
    final profileModel = ProfileModel(
      username: profile.username,
      displayName: profile.displayName,
      firstName: profile.firstName,
      lastName: profile.lastName,
      bio: profile.bio,
      dateOfBirth: profile.dateOfBirth,
      gender: profile.gender,
      address: profile.address,
      country: profile.country,
      state: profile.state,
      city: profile.city,
      zipCode: profile.zipCode,
      chasingCategory: profile.chasingCategory,
      chasingDescription: profile.chasingDescription,
      profileImageUrl: profile.profileImageUrl,
    );

    await firestore
        .collection('profiles')
        .doc(user.uid)
        .set(profileModel.toMap());
  }

  @override
  Future<ProfileModel> getProfile({required String uid}) async {
    final document = await firestore.collection('profiles').doc(uid).get();

    final data = document.data();

    if (data == null) {
      throw Exception('Profile not found');
    }

    return ProfileModel.fromMap(data);
  }

  @override
  Future<String> uploadProfileImage({
    required String imagePath,
    required String uid,
  }) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();

    final storage = supabase.storage.from('profile-images');

    final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final path = '$uid/$fileName';

    await storage.uploadBinary(
      path,
      bytes,
      fileOptions: const FileOptions(contentType: 'image/jpeg'),
    );

    return storage.getPublicUrl(path);
  }
}
