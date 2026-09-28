import 'package:social_media_app/features/profile/data/model/profile_model.dart';
import 'package:social_media_app/features/profile/domain/entities/profile.dart';

abstract class ProfileRemoteDataSource {
  Future<void> saveProfile({required Profile profile});
  Future<ProfileModel> getProfile({required String uid});

  Future<String> uploadProfileImage({
    required String imagePath,
    required String uid,
  });
}
