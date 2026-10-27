import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/search/domain/usecase/search_users_usecase.dart';
import 'package:social_media_app/features/search/presentation/bloc/search_users_state.dart';

class SearchUsersCubit extends Cubit<SearchUsersState> {
  final SearchUsersUsecase _searchUsersUsecase;
  SearchUsersCubit(this._searchUsersUsecase) : super(SearchUsersInitial());

  Future<void> searchUsers(String searchText) async {
    if (searchText.trim().isEmpty) {
      emit(SearchUsersInitial());
      return;
    }
    emit(SearchUsersLoading());
    try {
      final data = await _searchUsersUsecase.call(searchText);
      emit(SearchUsersLoaded(data));
    } catch (e) {
      emit(SearchUsersFailure(e.toString()));
    }
  }
}
