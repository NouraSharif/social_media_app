import 'package:social_media_app/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.id, required super.email});

  factory UserModel.fromFirebaseUser({
    required String id,
    required String email,
  }) {
    return UserModel(id: id, email: email);
  }
}
