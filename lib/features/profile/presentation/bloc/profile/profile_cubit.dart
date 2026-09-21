import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/domain/entities/profile.dart';
import 'package:social_media_app/features/profile/domain/usecase/get_profile.dart';
import 'package:social_media_app/features/profile/domain/usecase/save_profile.dart';
import 'package:social_media_app/features/profile/domain/usecase/upload_profile_image.dart';
import 'package:social_media_app/features/profile/presentation/bloc/profile/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final SaveProfile saveProfile;
  final GetProfile getProfile;
  final UploadProfileImage uploadProfileImage;
  ProfileCubit({
    required this.saveProfile,
    required this.getProfile,
    required this.uploadProfileImage,
  }) : super(ProfileInitial());

  Future<void> save(Profile profile, {String? imagePath}) async {
    try {
      emit(ProfileLoading());

      var profileToSave = profile;

      if (imagePath != null) {
        final imageUrl = await uploadProfileImage.call(imagePath);

        profileToSave = profile.copyWith(profileImageUrl: imageUrl);
      }

      await saveProfile.call(profile: profileToSave);

      emit(ProfileSuccess(profileToSave));
    } catch (e) {
      emit(ProfileFailure('Message Error: $e'));
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
