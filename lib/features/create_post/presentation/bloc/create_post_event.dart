import 'package:equatable/equatable.dart';

sealed class CreatePostEvent extends Equatable {
  const CreatePostEvent();
  @override
  List<Object?> get props => [];
}

class CreatePostContentChanged extends CreatePostEvent {
  final String content;
  const CreatePostContentChanged(this.content);
  @override
  List<Object?> get props => [content];
}

class CreatePostImagesChanged extends CreatePostEvent {
  final List<String> paths;
  const CreatePostImagesChanged(this.paths);
  @override
  List<Object?> get props => [paths];
}

class CreatePostSubmitted extends CreatePostEvent {
  const CreatePostSubmitted();
}
