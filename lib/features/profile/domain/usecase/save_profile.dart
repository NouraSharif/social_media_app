import 'package:social_media_app/features/profile/domain/entities/profile.dart';
import 'package:social_media_app/features/profile/domain/repository/profile_repository.dart';

class SaveProfile {
  final ProfileRepository profileRepository;

  SaveProfile(this.profileRepository);

  Future<void> call({required String uid, required Profile profile}) {
    return profileRepository.saveProfile(uid: uid, profile: profile);
  }
}
