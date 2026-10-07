import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/create_post_request.dart';
import '../../domain/usecases/create_post_usecase.dart';
import 'create_post_event.dart';
import 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final CreatePostUseCase createPostUseCase;
  CreatePostBloc({required this.createPostUseCase})
    : super(const CreatePostState()) {
    on<CreatePostContentChanged>((event, emit) {
      if (state.submissionStatus == CreatePostSubmissionStatus.submitting) {
        return;
      }
      emit(
        state.copyWith(
          content: event.content,
          submissionStatus: CreatePostSubmissionStatus.idle,
        ),
      );
    });
    on<CreatePostImagesChanged>((event, emit) {
      if (state.submissionStatus == CreatePostSubmissionStatus.submitting) {
        return;
      }
      emit(
        state.copyWith(
          imagePaths: List.unmodifiable(event.paths),
          submissionStatus: CreatePostSubmissionStatus.idle,
        ),
      );
    });
    on<CreatePostSubmitted>(_onSubmitted);
  }
  Future<void> _onSubmitted(
    CreatePostSubmitted event,
    Emitter<CreatePostState> emit,
  ) async {
    if (!state.canPost ||
        state.submissionStatus == CreatePostSubmissionStatus.submitting ||
        state.submissionStatus == CreatePostSubmissionStatus.success) {
      return;
    }
    final request = CreatePostRequest(
      content: state.content,
      category: state.category,
      imagePaths: state.imagePaths,
    );
    emit(
      state.copyWith(submissionStatus: CreatePostSubmissionStatus.submitting),
    );
    try {
      await createPostUseCase(request);
      emit(
        state.copyWith(submissionStatus: CreatePostSubmissionStatus.success),
      );
    } catch (e) {
      final message = e is FirebaseException
          ? (e.code == 'permission-denied'
                ? 'You do not have permission to post. Please try again later.'
                : 'Could not save the post. Check your connection and try again.')
          : e.toString().replaceFirst('Exception: ', '');
      emit(
        state.copyWith(
          submissionStatus: CreatePostSubmissionStatus.failure,
          errorMessage: message,
        ),
      );
    }
  }
}