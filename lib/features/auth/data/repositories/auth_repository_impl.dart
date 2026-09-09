import 'package:social_media_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:social_media_app/features/auth/domain/entities/user_entity.dart';
import 'package:social_media_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> signup({
    required String email,
    required String password,
  }) async {
    return await remoteDataSource.signup(
      email: email,
      password: password,
    );
  }
}