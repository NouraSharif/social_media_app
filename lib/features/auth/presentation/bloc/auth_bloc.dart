import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/domain/usecases/login.dart';

import '../../domain/usecases/signup.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignupUseCase signupUseCase;
  final LoginUseCase loginUseCase;

  AuthBloc(this.signupUseCase, this.loginUseCase) : super(AuthInitial()) {
    on<SignupRequested>(_onSignupRequested);
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await signupUseCase(email: event.email, password: event.password);

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await loginUseCase(email: event.email, password: event.password);

      emit(AuthSuccess());
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(AuthFailure(_getAuthErrorMessage(e)));
      } else {
        emit(AuthFailure('Something went wrong. Please try again.'));
      }
    }
  }
}

String _getAuthErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-credential':
      return 'Incorrect email or password.';
    case 'user-not-found':
      return 'No account found with this email.';
    case 'wrong-password':
      return 'Incorrect password.';
    case 'invalid-email':
      return 'Please enter a valid email.';
    case 'user-disabled':
      return 'This account has been disabled.';
    case 'too-many-requests':
      return 'Too many attempts. Please try again later.';
    case 'network-request-failed':
      return 'Please check your internet connection.';
    default:
      return 'Something went wrong. Please try again.';
  }
}
