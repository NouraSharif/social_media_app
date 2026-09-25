import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:social_media_app/features/auth/data/datasources/verification_remote_data_source_impl.dart';
import 'package:social_media_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:social_media_app/features/auth/data/repositories/verification_repository_impl.dart';
import 'package:social_media_app/features/auth/domain/repositories/verification_repository.dart';
import 'package:social_media_app/features/auth/domain/usecases/login.dart';
import 'package:social_media_app/features/auth/domain/usecases/reset_password.dart';
import 'package:social_media_app/features/auth/domain/usecases/send_reset_otp.dart';
import 'package:social_media_app/features/auth/domain/usecases/signup.dart';
import 'package:social_media_app/features/auth/domain/usecases/verification.dart';
import 'package:social_media_app/features/auth/domain/usecases/verify_reset_otp.dart';
import 'package:social_media_app/features/auth/presentation/bloc/verification/verification_cubit.dart';
import 'package:social_media_app/features/profile/data/datasource/profile_remote_data_source_impl.dart';
import 'package:social_media_app/features/profile/data/repository/profile_repository_impl.dart';
import 'package:social_media_app/features/profile/domain/usecase/get_profile.dart';
import 'package:social_media_app/features/profile/domain/usecase/save_profile.dart';
import 'package:social_media_app/features/profile/domain/usecase/upload_profile_image.dart';
import 'package:social_media_app/features/profile/presentation/bloc/profile/profile_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Authentication

final firebaseAuth = FirebaseAuth.instance;
final authRemoteDataSource = AuthRemoteDataSourceImpl(firebaseAuth);
final authRepository = AuthRepositoryImpl(authRemoteDataSource);
final signupUseCase = SignupUseCase(authRepository);
final loginUseCase = LoginUseCase(authRepository);

final sendResetOtpUseCase = SendResetOtpUseCase(authRepository);
final verifyResetUseCase = VerifyResetUseCase(authRepository);
final resetPasswordUseCase = ResetPasswordUseCase(authRepository);

// Verification

final supabase = SupabaseClient(
  'https://lprernyrsvifiohgaenb.supabase.co',
  'sb_publishable_-9Nm3TUzEZp96f2r0PIyJA_Rp3tXjyc',
  accessToken: () async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken(false);

    return token;
  },
);

final verificationRemoteDataSource = VerificationRemoteDataSourceImpl(
  supabase,
  firebaseAuth,
);

final VerificationRepository verificationRepository =
    VerificationRepositoryImpl(verificationRemoteDataSource);

final verificationUseCase = VerificationUseCase(verificationRepository);

final verificationCubit = VerificationCubit(verificationUseCase);

// Complete Profile

final firestore = FirebaseFirestore.instance;
final profileDataSource = ProfileRemoteDataSourceImpl(
  firestore,
  firebaseAuth,
  supabase,
);
final profileRepository = ProfileRepositoryImpl(
  profileDataSource,
  firebaseAuth,
);
final getProfile = GetProfile(profileRepository);
final saveProfile = SaveProfile(profileRepository);
final uploadProfileImage = UploadProfileImage(profileRepository);
final profileCubit = ProfileCubit(
  saveProfile: saveProfile,
  getProfile: getProfile,
  uploadProfileImage: uploadProfileImage,
);
