import 'package:social_media_app/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<void> saveProfile({required Profile profile});
  Future<Profile> getProfile({required String uid});
}
