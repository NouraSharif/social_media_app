import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/profile/data/datasource/profile_remote_data_source.dart';
import 'package:social_media_app/features/profile/data/model/profile_model.dart';
import 'package:social_media_app/features/profile/domain/entities/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsernameAlreadyTakenException implements Exception {
  const UsernameAlreadyTakenException();
}

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

    final uid = user.uid;

    // Normalize the username to one consistent format.
    var username = profile.username.trim().toLowerCase();

    if (!username.startsWith('@')) {
      username = '@$username';
    }

    // Validate the normalized username.
    if (!RegExp(r'^@[a-z0-9_]+$').hasMatch(username)) {
      throw Exception('Invalid username format.');
    }

    final profileRef = firestore.collection('profiles').doc(uid);
    final newUsernameRef = firestore.collection('usernames').doc(username);

    final profileModel = ProfileModel(
      username: username,
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

    await firestore.runTransaction<void>((transaction) async {
      // Read the current profile and requested username first.
      final profileSnapshot = await transaction.get(profileRef);
      final newUsernameSnapshot = await transaction.get(newUsernameRef);

      final oldUsername = (profileSnapshot.data()?['username'] as String? ?? '')
          .trim()
          .toLowerCase();

      // Read the old reservation if the username is changing.
      DocumentSnapshot<Map<String, dynamic>>? oldUsernameSnapshot;

      if (oldUsername.isNotEmpty && oldUsername != username) {
        final oldUsernameRef = firestore
            .collection('usernames')
            .doc(oldUsername);

        oldUsernameSnapshot = await transaction.get(oldUsernameRef);
      }

      // Reject a username reserved by another user.
      if (newUsernameSnapshot.exists &&
          newUsernameSnapshot.data()?['uid'] != uid) {
        throw const UsernameAlreadyTakenException();
      }

      // Release the old reservation only if it belongs to this user.
      if (oldUsername.isNotEmpty && oldUsername != username) {
        final oldUsernameRef = firestore
            .collection('usernames')
            .doc(oldUsername);

        if (oldUsernameSnapshot?.exists == true &&
            oldUsernameSnapshot?.data()?['uid'] == uid) {
          transaction.delete(oldUsernameRef);
        }
      }

      // Reserve the new username for this user.
      transaction.set(newUsernameRef, {'uid': uid, 'username': username});

      // Save the updated profile.
      transaction.set(profileRef, profileModel.toMap());
    });
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

  @override
  Future<void> createBasicProfile({
    required String uid,
    required String email,
  }) async {
    final emailPrefix = email.split('@').first;

    // Generate a username base using lowercase letters, digits, and underscores.
    var baseUsername = emailPrefix
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');

    if (baseUsername.isEmpty) {
      baseUsername = 'user';
    }

    final profileRef = firestore.collection('profiles').doc(uid);
    final usernamesRef = firestore.collection('usernames');

    final random = Random.secure();

    // Retry with another suffix if the username is already taken.
    for (var attempt = 0; attempt < 10; attempt++) {
      final suffix = random.nextInt(9000) + 1000;
      final username = '@${baseUsername}_$suffix';
      final usernameRef = usernamesRef.doc(username);

      final created = await firestore.runTransaction<bool>((transaction) async {
        final profileSnapshot = await transaction.get(profileRef);

        // Don't overwrite an existing profile.
        if (profileSnapshot.exists) {
          return true;
        }

        final usernameSnapshot = await transaction.get(usernameRef);

        if (usernameSnapshot.exists) {
          return false;
        }

        transaction.set(usernameRef, {'uid': uid, 'username': username});

        transaction.set(profileRef, {
          'username': username,
          'displayName': emailPrefix,
          'firstName': '',
          'lastName': '',
          'bio': '',
          'dateOfBirth': '',
          'gender': '',
          'address': '',
          'country': '',
          'state': '',
          'city': '',
          'zipCode': '',
          'chasingCategory': '',
          'chasingDescription': '',
          'profileImageUrl': null,
        });

        return true;
      });

      if (created) {
        return;
      }
    }

    throw Exception('Could not generate a unique username. Please try again.');
  }
}
