import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/chat/domain/entities/new_message_user.dart';
import 'package:social_media_app/features/chat/domain/usecases/new_message_search_users_usecase.dart';
import 'package:social_media_app/features/chat/domain/usecases/new_message_user_usecase.dart';
import 'package:social_media_app/features/chat/presentation/bloc/new_message_user_state.dart';

class NewMessageUserCubit extends Cubit<NewMessageUserState> {
  final NewMessageUserUsecase _newMessageUserUseCase;
  final NewMessageSearchUsersUsecase _newMessageSearchUsersUsecase;
  StreamSubscription? _newMessageUserSubscription;

  NewMessageUserCubit({
    required NewMessageUserUsecase newMessageUserUseCase,
    required this._newMessageSearchUsersUsecase,
  }) : _newMessageUserUseCase = newMessageUserUseCase,
       super(NewMessageUserInitial());

  Future<void> getMessageUsers() async {
    emit(NewMessageUserLoading());

    await _newMessageUserSubscription?.cancel();
    _newMessageUserSubscription = _newMessageUserUseCase.call().listen(
      (data) => emit(NewMessageUserLoaded(data)),
      onError: (e) => emit(NewMessageUserFailure(e.toString())),
    );
  }

  @override
  Future<void> close() async {
    await _newMessageUserSubscription?.cancel();
    await super.close();
  }

  Future<List<NewMessageUserEntity>> searchUsers(String searchText) async {
    emit(NewMessageUserLoading());
    final data = await _newMessageSearchUsersUsecase.call(searchText);
    emit(NewMessageSearchUsersLoaded(data));
    return data;
  }
}
