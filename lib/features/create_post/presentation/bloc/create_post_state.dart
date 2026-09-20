import 'package:equatable/equatable.dart';

enum CreatePostSubmissionStatus { idle, submitting, success, failure }

class CreatePostState extends Equatable {
  final String content;
  final String category;
  final int? selectedPhotoIndex;
  final CreatePostSubmissionStatus submissionStatus;
  final String? errorMessage;

  const CreatePostState({
    this.content = '',
    this.category = 'Chasing',
    this.selectedPhotoIndex,
    this.submissionStatus = CreatePostSubmissionStatus.idle,
    this.errorMessage,
  });
  
  bool get canPost => content.trim().isNotEmpty || selectedPhotoIndex != null;

  CreatePostState copyWith({
    String? content,
    String? category,
    int? selectedPhotoIndex,
    bool clearSelectedPhoto = false,
    CreatePostSubmissionStatus? submissionStatus,
    String? errorMessage,
  }) {
    return CreatePostState(
      content: content ?? this.content,
      category: category ?? this.category,
      selectedPhotoIndex:
      clearSelectedPhoto ? null : (selectedPhotoIndex ?? this.selectedPhotoIndex),
      submissionStatus: submissionStatus ?? this.submissionStatus,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [content, category, selectedPhotoIndex, submissionStatus, errorMessage];
}