import 'package:social_media_app/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<void> saveProfile({required Profile profile});

  Future<Profile> getProfile({required String uid});

  Future<String> uploadProfileImage(String imagePath);

  Future<void> createBasicProfile({required String uid, required String email});

  Future<void> updateProfile({required Profile profile});
}
