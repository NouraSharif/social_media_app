import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/chat/domain/usecases/new_message_user_usecase.dart';
import 'package:social_media_app/features/chat/presentation/bloc/new_message_user_state.dart';

class NewMessageUserCubit extends Cubit<NewMessageUserState> {
  final NewMessageUserUsecase _newMessageUserUseCase;

  StreamSubscription? _newMessageUserSubscription;

  NewMessageUserCubit({required NewMessageUserUsecase newMessageUserUseCase})
    : _newMessageUserUseCase = newMessageUserUseCase,
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
}
