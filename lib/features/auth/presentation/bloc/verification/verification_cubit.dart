import 'dart:io';

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
      emit(VerificationFailure(_getVerificationErrorMessage(e)));
    }
  }
}

String _getVerificationErrorMessage(Object e) {
  final message = e.toString();

  if (message.contains('network')) {
    return 'Please check your internet connection.';
  }

  if (message.contains('size')) {
    return 'The image size is too large.';
  }

  if (message.contains('format')) {
    return 'Please upload a valid image format.';
  }

  if (message.contains('already')) {
    return 'This document has already been uploaded.';
  }

  return 'Something went wrong while uploading documents.';
}
