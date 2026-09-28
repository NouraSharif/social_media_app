import '../repositories/auth_repository.dart';

class VerifyResetUseCase {
  final AuthRepository repository;

  VerifyResetUseCase(this.repository);

  Future<String> call({required String email, required String otp}) async {
    return await repository.verifyResetOtp(email: email, otp: otp);
  }
}
