import 'package:social_media_app/features/profile/domain/entities/profile.dart';
import 'package:social_media_app/features/profile/domain/repository/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository profileRepository;

  UpdateProfile(this.profileRepository);

  Future<void> call({required Profile profile}) {
    return profileRepository.updateProfile(profile: profile);
  }
}
