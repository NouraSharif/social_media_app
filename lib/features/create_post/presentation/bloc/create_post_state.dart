import 'package:equatable/equatable.dart';

enum CreatePostSubmissionStatus { idle, submitting, success, failure }

class CreatePostState extends Equatable {
  final String content;
  final List<String> imagePaths;
  final CreatePostSubmissionStatus submissionStatus;
  final String? errorMessage;
  const CreatePostState({
    this.content = '',
    this.imagePaths = const [],
    this.submissionStatus = CreatePostSubmissionStatus.idle,
    this.errorMessage,
  });
  String get category => 'Chasing';
  bool get canPost => content.trim().isNotEmpty || imagePaths.isNotEmpty;
  CreatePostState copyWith({
    String? content,
    List<String>? imagePaths,
    CreatePostSubmissionStatus? submissionStatus,
    String? errorMessage,
  }) {
    return CreatePostState(
      content: content ?? this.content,
      imagePaths: imagePaths ?? this.imagePaths,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    content,
    imagePaths,
    submissionStatus,
    errorMessage,
  ];
}
