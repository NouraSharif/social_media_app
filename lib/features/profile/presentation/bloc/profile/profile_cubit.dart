import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/domain/entities/profile.dart';
import 'package:social_media_app/features/profile/domain/usecase/get_profile.dart';
import 'package:social_media_app/features/profile/domain/usecase/save_profile.dart';
import 'package:social_media_app/features/profile/presentation/bloc/profile/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final SaveProfile saveProfile;
  final GetProfile getProfile;
  ProfileCubit({required this.saveProfile, required this.getProfile})
    : super(ProfileInitial());

  Future<void> save(Profile profile) async {
    try {
      emit(ProfileLoading());

      await saveProfile.call(profile: profile);
      emit(ProfileSuccess(profile));
    } catch (e) {
      emit(ProfileFailure("Message Error:$e"));
    }
  }

  Future<void> get(String uid) async {
    try {
      emit(ProfileLoading());

      final profile = await getProfile.call(uid: uid);
      emit(ProfileSuccess(profile));
    } catch (e) {
      emit(ProfileFailure("Message Error:$e"));
    }
  }
}
