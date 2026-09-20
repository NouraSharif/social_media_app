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

class CreatePostCategoryChanged extends CreatePostEvent {
  final String category;
  const CreatePostCategoryChanged(this.category);
  @override
  List<Object?> get props => [category];
}

class CreatePostPhotoSelected extends CreatePostEvent {
  final int? index; // null = إلغاء الاختيار
  const CreatePostPhotoSelected(this.index);
  @override
  List<Object?> get props => [index];
}

class CreatePostSubmitted extends CreatePostEvent {
  const CreatePostSubmitted();
}