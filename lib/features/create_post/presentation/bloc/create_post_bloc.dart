import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/create_post_request.dart';
import '../../domain/usecases/create_post_usecase.dart';
import 'create_post_event.dart';
import 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final CreatePostUseCase createPostUseCase;

  CreatePostBloc({required this.createPostUseCase}) : super(const CreatePostState()) {
    on<CreatePostContentChanged>(_onContentChanged);
    on<CreatePostCategoryChanged>(_onCategoryChanged);
    on<CreatePostPhotoSelected>(_onPhotoSelected);
    on<CreatePostSubmitted>(_onSubmitted);
  }

  void _onContentChanged(CreatePostContentChanged event, Emitter<CreatePostState> emit) {
    emit(state.copyWith(content: event.content));
  }

  void _onCategoryChanged(CreatePostCategoryChanged event, Emitter<CreatePostState> emit) {
    emit(state.copyWith(category: event.category));
  }

  void _onPhotoSelected(CreatePostPhotoSelected event, Emitter<CreatePostState> emit) {
    if (event.index == null || state.selectedPhotoIndex == event.index) {
      emit(state.copyWith(clearSelectedPhoto: true));
    } else {
      emit(state.copyWith(selectedPhotoIndex: event.index));
    }
  }

  Future<void> _onSubmitted(CreatePostSubmitted event, Emitter<CreatePostState> emit) async {
    if (!state.canPost) return;

    emit(state.copyWith(submissionStatus: CreatePostSubmissionStatus.submitting));
    try {
      await createPostUseCase(CreatePostRequest(
        content: state.content,
        category: state.category,
        imagePath: null,  ));
      emit(state.copyWith(submissionStatus: CreatePostSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        submissionStatus: CreatePostSubmissionStatus.failure,
        errorMessage: 'failed to post, try again.',
      ));
    }
  }
}