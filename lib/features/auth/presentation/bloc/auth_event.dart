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
