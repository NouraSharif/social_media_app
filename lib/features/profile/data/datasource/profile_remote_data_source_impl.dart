import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/profile/data/datasource/profile_remote_data_source.dart';
import 'package:social_media_app/features/profile/data/model/profile_model.dart';
import 'package:social_media_app/features/profile/domain/entities/profile.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  ProfileRemoteDataSourceImpl(this.firestore);
  @override
  Future<void> saveProfile({
    required String uid,
    required Profile profile,
  }) async {
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

    await firestore.collection('profiles').doc(uid).set(profileModel.toMap());
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
}
