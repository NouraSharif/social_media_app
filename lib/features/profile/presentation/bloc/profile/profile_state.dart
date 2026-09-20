import 'package:equatable/equatable.dart';
import 'package:social_media_app/features/profile/domain/entities/profile.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final Profile profile;
  const ProfileSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileFailure extends ProfileState {
  final String message;
  const ProfileFailure(this.message);

  @override
  List<Object?> get props => [message];
}
