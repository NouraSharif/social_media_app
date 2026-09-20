import 'package:social_media_app/features/profile/domain/entities/profile.dart';
import 'package:social_media_app/features/profile/domain/repository/profile_repository.dart';

class GetProfile {
  final ProfileRepository profileRepository;

  GetProfile(this.profileRepository);

  Future<Profile> call({required String uid}) {
    return profileRepository.getProfile(uid: uid);
  }
}
