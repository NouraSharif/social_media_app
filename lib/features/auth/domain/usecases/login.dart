import 'package:social_media_app/features/auth/domain/entities/user_entity.dart';
import 'package:social_media_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;
  LoginUseCase(this.authRepository);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) async {
    return await authRepository.login(email: email, password: password);
  }
}
