import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/profile/data/datasource/profile_remote_data_source.dart';
import 'package:social_media_app/features/profile/domain/entities/profile.dart';
import 'package:social_media_app/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource dataSource;
  final FirebaseAuth firebaseAuth;
  ProfileRepositoryImpl(this.dataSource, this.firebaseAuth);

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
}
