import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/features/auth/domain/usecases/login.dart';
import 'package:social_media_app/features/auth/domain/usecases/reset_password.dart';
import 'package:social_media_app/features/auth/domain/usecases/send_reset_otp.dart';
import 'package:social_media_app/features/auth/domain/usecases/verify_reset_otp.dart';
import 'package:social_media_app/features/auth/presentation/bloc/auth/auth_state.dart';

import '../../../domain/usecases/signup.dart';
import 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignupUseCase signupUseCase;
  final LoginUseCase loginUseCase;

  final SendResetOtpUseCase sendResetOtpUseCase;
  final VerifyResetUseCase verifyResetUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthBloc(
    this.signupUseCase,
    this.loginUseCase,
    this.sendResetOtpUseCase,
    this.verifyResetUseCase,
    this.resetPasswordUseCase,
  ) : super(AuthInitial()) {
    on<SignupRequested>(_onSignupRequested);
    on<LoginRequested>(_onLoginRequested);
    on<SendResetOtpRequested>(_onSendResetOtpRequested);
    on<VerifyResetOtpRequested>(_onVerifyResetOtpRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
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
      if (e is FirebaseAuthException) {
        emit(AuthFailure(_getAuthErrorMessage(e)));
      } else {
        emit(AuthFailure('Something went wrong. Please try again.'));
      }
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

Future<void> _onSendResetOtpRequested(
  SendResetOtpRequested event,
  Emitter<AuthState> emit,
) async {
  emit(AuthLoading());

  try {
    await sendResetOtpUseCase(email: event.email);

    emit(AuthSuccess());
  } catch (e) {
    emit(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
  }
}

Future<void> _onVerifyResetOtpRequested(
  VerifyResetOtpRequested event,
  Emitter<AuthState> emit,
) async {
  emit(AuthLoading());

  try {
    final resetToken = await verifyResetUseCase(
      email: event.email,
      otp: event.otp,
    );

    emit(AuthResetOtpVerified(resetToken));
  } catch (e) {
    emit(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
  }
}

Future<void> _onResetPasswordRequested(
  ResetPasswordRequested event,
  Emitter<AuthState> emit,
) async {
  emit(AuthLoading());

  try {
    await resetPasswordUseCase(
      email: event.email,
      resetToken: event.resetToken,
      newPassword: event.newPassword,
    );

    emit(AuthSuccess());
  } catch (e) {
    emit(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
  }
}

String _getAuthErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'email-already-in-use':
      return 'This email is already registered.';
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
