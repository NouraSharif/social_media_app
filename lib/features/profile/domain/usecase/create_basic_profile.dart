import 'package:social_media_app/features/profile/domain/repository/profile_repository.dart';

class CreateBasicProfile {
  final ProfileRepository repository;

  CreateBasicProfile(this.repository);

  Future<void> call({required String uid, required String email}) {
    return repository.createBasicProfile(uid: uid, email: email);
  }
}
