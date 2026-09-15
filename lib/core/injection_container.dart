import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:social_media_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:social_media_app/features/auth/domain/usecases/login.dart';
import 'package:social_media_app/features/auth/domain/usecases/reset_password.dart';
import 'package:social_media_app/features/auth/domain/usecases/send_reset_otp.dart';
import 'package:social_media_app/features/auth/domain/usecases/signup.dart';
import 'package:social_media_app/features/auth/domain/usecases/verify_reset_otp.dart';

// Authentication

final firebaseAuth = FirebaseAuth.instance;
final authRemoteDataSource = AuthRemoteDataSourceImpl(firebaseAuth);
final authRepository = AuthRepositoryImpl(authRemoteDataSource);
final signupUseCase = SignupUseCase(authRepository);
final loginUseCase = LoginUseCase(authRepository);

final sendResetOtpUseCase = SendResetOtpUseCase(authRepository);
final verifyResetUseCase = VerifyResetUseCase(authRepository);
final resetPasswordUseCase = ResetPasswordUseCase(authRepository);
