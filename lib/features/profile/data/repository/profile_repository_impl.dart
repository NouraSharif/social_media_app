import 'package:social_media_app/features/profile/data/datasource/profile_remote_data_source.dart';
import 'package:social_media_app/features/profile/domain/entities/profile.dart';
import 'package:social_media_app/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRemoteDataSource dataSource;
  ProfileRepositoryImpl(this.dataSource);

  @override
  Future<void> saveProfile({required String uid, required Profile profile}) {
    return dataSource.saveProfile(uid: uid, profile: profile);
  }

  @override
  Future<Profile> getProfile({required String uid}) {
    return dataSource.getProfile(uid: uid);
  }
}
