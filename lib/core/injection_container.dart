import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/profile/data/datasource/profile_remote_data_source_impl.dart';
import 'package:social_media_app/features/profile/data/repository/profile_repository_impl.dart';
import 'package:social_media_app/features/profile/domain/usecase/get_profile.dart';
import 'package:social_media_app/features/profile/domain/usecase/save_profile.dart';
import 'package:social_media_app/features/profile/domain/usecase/upload_profile_image.dart';
import 'package:social_media_app/features/profile/presentation/bloc/profile/profile_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Complete Profile

final authFirebase = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;
final supabase = Supabase.instance.client;
final dataSource = ProfileRemoteDataSourceImpl(
  firestore,
  authFirebase,
  supabase,
);
final profileRepository = ProfileRepositoryImpl(dataSource, authFirebase);
final getProfile = GetProfile(profileRepository);
final saveProfile = SaveProfile(profileRepository);
final uploadProfileImage = UploadProfileImage(profileRepository);
final profileCubit = ProfileCubit(
  saveProfile: saveProfile,
  getProfile: getProfile,
  uploadProfileImage: uploadProfileImage,
);
