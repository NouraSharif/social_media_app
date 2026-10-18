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
import 'package:social_media_app/features/chat/data/datasource/chat/chat_image_storage_data_source_impl.dart';
import 'package:social_media_app/features/chat/data/datasource/chat/chat_remote_data_source_impl.dart';
import 'package:social_media_app/features/chat/data/datasource/chats/chats_remote_data_source_impl.dart';
import 'package:social_media_app/features/chat/data/repository/chat_image_storage_repository_impl.dart';
import 'package:social_media_app/features/chat/data/repository/chat_repository_impl.dart';
import 'package:social_media_app/features/chat/data/repository/chats_repository_impl.dart';
import 'package:social_media_app/features/chat/domain/usecases/chats/delete_chat.dart';
import 'package:social_media_app/features/chat/domain/usecases/chats/get_chats.dart';
import 'package:social_media_app/features/chat/domain/usecases/chat/get_messages.dart';
import 'package:social_media_app/features/chat/domain/usecases/chat/send_message.dart';
import 'package:social_media_app/features/chat/domain/usecases/chat/upload_chat_image_usecase.dart';
import 'package:social_media_app/features/profile/data/datasource/profile_remote_data_source_impl.dart';
import 'package:social_media_app/features/profile/data/repository/profile_repository_impl.dart';
import 'package:social_media_app/features/profile/domain/usecase/get_profile.dart';
import 'package:social_media_app/features/profile/domain/usecase/save_profile.dart';
import 'package:social_media_app/features/profile/domain/usecase/upload_profile_image.dart';
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

// Chat
final chatsRemoteDataSource = ChatsRemoteDataSourceImpl(
  firebaseAuth,
  firestore,
);
final chatsRepository = ChatsRepositoryImpl(chatsRemoteDataSource);
final getChatsUseCase = GetChatsUseCase(chatsRepository);
final deleteChatUseCase = DeleteChatUseCase(chatsRepository);

final chatDataSource = ChatRemoteDataSourceImpl(firestore, firebaseAuth);
final chatRepository = ChatRepositoryImpl(chatDataSource);
final sendMessageUseCase = SendMessageUseCase(chatRepository);
final getMessagesUseCase = GetMessagesUseCase(chatRepository);
final chatImageStorageDataSource = ChatImageStorageDataSourceImpl(
  Supabase.instance.client,
  firebaseAuth,
);

final chatImageStorageRepository = ChatImageStorageRepositoryImpl(
  chatImageStorageDataSource,
);

final uploadChatImageUseCase = UploadChatImageUseCase(
  chatImageStorageRepository,
);
