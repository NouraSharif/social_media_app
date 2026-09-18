import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/domain/usecases/verification.dart';
import 'package:social_media_app/features/auth/presentation/bloc/verification/verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  final VerificationUseCase verificationUseCase;

  VerificationCubit(this.verificationUseCase) : super(VerificationInitial());

  Future<void> uploadDocuments({
    required String verificationType,
    required File imageFront,
    required File imageBack,
  }) async {
    try {
      emit(VerificationLoading());

      await verificationUseCase(
        verificationType: verificationType,
        imageFront: imageFront,
        imageBack: imageBack,
      );

      emit(VerificationSuccess());
    } catch (e) {
      emit(VerificationFailure(e.toString()));
    }
  }
}
