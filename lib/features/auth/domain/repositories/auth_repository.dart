import 'package:social_media_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signup({required String email, required String password});
  Future<UserEntity> login({required String email, required String password});
}
