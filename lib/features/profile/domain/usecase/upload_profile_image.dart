import 'package:social_media_app/features/profile/domain/repository/profile_repository.dart';

class UploadProfileImage {
  final ProfileRepository profileRepository;

  UploadProfileImage(this.profileRepository);

  Future<String> call(String imagePath) {
    return profileRepository.uploadProfileImage(imagePath);
  }
}
