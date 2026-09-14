import 'package:social_media_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signup({required String email, required String password});
  Future<UserModel> login({required String email, required String password});
}
