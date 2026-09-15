import '../repositories/auth_repository.dart';

class SendResetOtpUseCase {
  final AuthRepository repository;

  SendResetOtpUseCase(this.repository);

  Future<void> call({required String email}) {
    return repository.sendResetOtp(email: email);
  }
}
