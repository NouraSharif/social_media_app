import 'package:equatable/equatable.dart';
import 'package:social_media_app/features/search/domain/entity/search_user.dart';

sealed class SearchUsersState extends Equatable {
  const SearchUsersState();

  @override
  List<Object?> get props => [];
}

class SearchUsersInitial extends SearchUsersState {}

class SearchUsersLoading extends SearchUsersState {}

class SearchUsersLoaded extends SearchUsersState {
  final List<SearchUserEntity> data;
  const SearchUsersLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class SearchUsersFailure extends SearchUsersState {
  final String message;
  const SearchUsersFailure(this.message);

  @override
  List<Object?> get props => [message];
}
