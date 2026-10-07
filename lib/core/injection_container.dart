import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:get_it/get_it.dart';
import 'package:social_media_app/features/create_post/data/datasources/create_post_remote_datasource.dart';
import 'package:social_media_app/features/create_post/data/repositories/create_post_repository_impl.dart';
import 'package:social_media_app/features/create_post/domain/repositories/create_post_repository.dart';

import '../features/post_details/data/datasources/comment_remote_datasource.dart';
import '../features/post_details/data/repositories/comment_repository_impl.dart';
import '../features/post_details/domain/repositories/comment_repository.dart';
import '../features/post_details/domain/usecases/get_comments_usecase.dart';
import '../features/post_details/domain/usecases/add_comment_usecase.dart';
import '../features/post_details/domain/usecases/toggle_comment_like_usecase.dart';
import '../features/create_post/domain/usecases/create_post_usecase.dart';
import 'data/datasources/post_remote_datasource.dart';
import 'data/repositories/post_repository_impl.dart';
import 'domain/repositories/post_repository.dart';
import 'domain/usecases/get_post_by_id_usecase.dart';
import 'domain/usecases/get_posts_usecase.dart';
import 'domain/usecases/toggle_post_like_usecase.dart';

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

final GetIt sl = GetIt.instance;
void setupDependencies() {
  // datasources - lazy singletons
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSource(firestore, firebaseAuth),
  );
  sl.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSource(firestore, firebaseAuth),
  );
  sl.registerLazySingleton<CreatePostRemoteDataSource>(
    () => CreatePostRemoteDataSourceImpl(firestore, firebaseAuth, supabase),
  );

  // repositories
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(sl()));
  sl.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<CreatePostRepository>(
    () => CreatePostRepositoryImpl(sl()),
  );

  // usecases - factory new instance in each call
  sl.registerFactory(() => GetPostsUseCase(sl()));
  sl.registerFactory(() => GetPostByIdUseCase(sl()));
  sl.registerFactory(() => TogglePostLikeUseCase(sl()));
  sl.registerFactory(() => CreatePostUseCase(sl()));
  //------------------
  sl.registerFactory(() => GetCommentsUseCase(sl()));
  sl.registerFactory(() => AddCommentUseCase(sl()));
  sl.registerFactory(() => ToggleCommentLikeUseCase(sl()));
}

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
