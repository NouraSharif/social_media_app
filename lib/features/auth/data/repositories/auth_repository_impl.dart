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
    return await remoteDataSource.signup(email: email, password: password);
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    return await remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<void> sendResetOtp({required String email}) {
    return remoteDataSource.sendResetOtp(email: email);
  }

  @override
  Future<String> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    return await remoteDataSource.verifyResetOtp(email: email, otp: otp);
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
  }) {
    return remoteDataSource.resetPassword(
      email: email,
      resetToken: resetToken,
      newPassword: newPassword,
    );
  }
}
