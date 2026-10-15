import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/profile/data/datasource/profile_remote_data_source.dart';
import 'package:social_media_app/features/profile/data/model/profile_model.dart';
import 'package:social_media_app/features/profile/domain/entities/profile.dart';
import 'package:social_media_app/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource dataSource;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  ProfileRepositoryImpl(this.dataSource, this.firebaseAuth, this.firestore);

  @override
  Future<void> saveProfile({required Profile profile}) {
    return dataSource.saveProfile(profile: profile);
  }

  @override
  Future<Profile> getProfile({required String uid}) {
    return dataSource.getProfile(uid: uid);
  }

  @override
  Future<String> uploadProfileImage(String imagePath) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    return dataSource.uploadProfileImage(imagePath: imagePath, uid: user.uid);
  }

  @override
  Future<void> createBasicProfile({
    required String uid,
    required String email,
  }) {
    return dataSource.createBasicProfile(uid: uid, email: email);
  }

  @override
  Future<void> updateProfile({required Profile profile}) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final newUsername = profile.username.trim().toLowerCase();

    if (!RegExp(r'^@[a-z0-9_]+$').hasMatch(newUsername)) {
      throw Exception(
        'Username must start with @ and contain only lowercase English letters, numbers, and underscores.',
      );
    }

    final profileRef = firestore.collection('profiles').doc(user.uid);
    final usernamesRef = firestore.collection('usernames');
    final newUsernameRef = usernamesRef.doc(newUsername);

    final updatedProfile = ProfileModel(
      username: newUsername,
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

    await firestore.runTransaction((transaction) async {
      // 1. Read the existing profile.
      final profileSnapshot = await transaction.get(profileRef);

      if (!profileSnapshot.exists) {
        throw Exception('Profile not found');
      }

      final currentData = profileSnapshot.data()!;
      final oldUsername = (currentData['username'] as String? ?? '')
          .trim()
          .toLowerCase();

      // 2. Read the new username reservation.
      final newUsernameSnapshot = await transaction.get(newUsernameRef);

      // 3. Read the old reservation if the username is changing.
      DocumentSnapshot<Map<String, dynamic>>? oldUsernameSnapshot;

      if (oldUsername.isNotEmpty && oldUsername != newUsername) {
        final oldUsernameRef = usernamesRef.doc(oldUsername);
        oldUsernameSnapshot = await transaction.get(oldUsernameRef);
      }

      // All transaction reads are complete. Now we can write.

      final reservedUid = newUsernameSnapshot.data()?['uid'];

      if (newUsernameSnapshot.exists && reservedUid != user.uid) {
        throw Exception('Username is already taken');
      }

      // Release the old username only if this user owns its reservation.
      if (oldUsernameSnapshot != null &&
          oldUsernameSnapshot.exists &&
          oldUsernameSnapshot.data()?['uid'] == user.uid) {
        transaction.delete(usernamesRef.doc(oldUsername));
      }

      // Reserve the new username for this user.
      transaction.set(newUsernameRef, {
        'uid': user.uid,
        'username': newUsername,
      });

      // Update the existing profile document.
      transaction.set(profileRef, updatedProfile.toMap());
    });
  }
}
