import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignupRequested extends AuthEvent {
  final String email;
  final String password;

  const SignupRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SendResetOtpRequested extends AuthEvent {
  final String email;

  const SendResetOtpRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class VerifyResetOtpRequested extends AuthEvent {
  final String email;
  final String otp;

  const VerifyResetOtpRequested({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class ResetPasswordRequested extends AuthEvent {
  final String email;
  final String resetToken;
  final String newPassword;

  const ResetPasswordRequested({
    required this.email,
    required this.resetToken,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, resetToken, newPassword];
}
