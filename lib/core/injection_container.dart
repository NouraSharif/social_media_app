import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/profile/data/datasource/profile_remote_data_source_impl.dart';
import 'package:social_media_app/features/profile/data/repository/profile_repository_impl.dart';
import 'package:social_media_app/features/profile/domain/usecase/get_profile.dart';
import 'package:social_media_app/features/profile/domain/usecase/save_profile.dart';
import 'package:social_media_app/features/profile/presentation/bloc/profile/prifile_cubit.dart';

// Complete Profile
final firestore = FirebaseFirestore.instance;
final dataSource = ProfileRemoteDataSourceImpl(firestore);
final profileRepository = ProfileRepositoryImpl(dataSource);
final getProfile = GetProfile(profileRepository);
final saveProfile = SaveProfile(profileRepository);
final profileCubit = ProfileCubit(
  saveProfile: saveProfile,
  getProfile: getProfile,
);
