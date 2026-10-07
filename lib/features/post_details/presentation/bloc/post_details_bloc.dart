import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/domain/usecases/get_post_by_id_usecase.dart';
import 'package:social_media_app/core/domain/usecases/toggle_post_like_usecase.dart';
import 'package:social_media_app/core/error/exceptions.dart';
import 'package:social_media_app/features/post_details/domain/entities/comment_entity.dart';
import 'package:social_media_app/features/post_details/domain/usecases/add_comment_usecase.dart';
import 'package:social_media_app/features/post_details/domain/usecases/get_comments_usecase.dart';

import 'post_details_event.dart';
import 'post_details_state.dart';

class PostDetailsBloc extends Bloc<PostDetailsEvent, PostDetailsState> {
  final GetPostByIdUseCase getPostByIdUseCase;
  final TogglePostLikeUseCase togglePostLikeUseCase;
  final GetCommentsUseCase getCommentsUseCase;
  final AddCommentUseCase addCommentUseCase;
  late String _postId;

  PostDetailsBloc({
    required this.getPostByIdUseCase,
    required this.togglePostLikeUseCase,
    required this.getCommentsUseCase,
    required this.addCommentUseCase,
  }) : super(const PostDetailsState()) {
    on<PostDetailsRequested>(_onRequested);
    on<PostDetailsPostLikeToggled>(_onPostLikeToggled);
    on<PostDetailsCommentSubmitted>(_onCommentSubmitted);
  }

  Future<void> _onRequested(
    PostDetailsRequested event,
    Emitter<PostDetailsState> emit,
  ) async {
    _postId = event.postId;
    emit(state.copyWith(status: PostDetailsStatus.loading));
    try {
      final post = await getPostByIdUseCase(_postId);
      final comments = await getCommentsUseCase(_postId);
      emit(
        state.copyWith(
          status: PostDetailsStatus.success,
          post: post,
          comments: comments,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: e is PostNotFoundException
              ? PostDetailsStatus.notFound
              : PostDetailsStatus.failure,
          errorMessage: 'Could not load this post. Please try again.',
        ),
      );
    }
  }

  Future<void> _onPostLikeToggled(
    PostDetailsPostLikeToggled event,
    Emitter<PostDetailsState> emit,
  ) async {
    if (state.isLiking || state.isSubmitting || state.post == null) return;
    emit(state.copyWith(isLiking: true));
    try {
      final updated = await togglePostLikeUseCase(state.post!);
      emit(state.copyWith(post: updated, isLiking: false));
    } catch (_) {
      emit(
        state.copyWith(
          isLiking: false,
          errorMessage: 'Could not update like. Check your connection and sign-in, then try again.',
        ),
      );
    }
  }

  Future<void> _onCommentSubmitted(
    PostDetailsCommentSubmitted event,
    Emitter<PostDetailsState> emit,
  ) async {
    if (state.isSubmitting || state.isLiking || state.post == null) return;
    final text = event.content.trim();
    if (text.isEmpty || text.length > 2000) return;
    emit(state.copyWith(isSubmitting: true));
    try {
      final saved = await addCommentUseCase(
        CommentEntity(
          id: '',
          postId: _postId,
          userName: '',
          timeAgo: '',
          content: text,
        ),
      );
      emit(
        state.copyWith(
          comments: [saved, ...state.comments],
          post: state.post!.copyWith(
            commentsCount: state.post!.commentsCount + 1,
          ),
          submittedCount: state.submittedCount + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Could not send comment. Check your connection and sign-in, then try again.',
        ),
      );
      return;
    }
    // A refresh failure must not turn a committed comment into a failed submission.
    try {
      final post = await getPostByIdUseCase(_postId);
      final comments = await getCommentsUseCase(_postId);
      emit(state.copyWith(post: post, comments: comments, isSubmitting: false));
    } catch (_) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Comment sent. Could not refresh the latest comments.',
        ),
      );
    }
  }
}
