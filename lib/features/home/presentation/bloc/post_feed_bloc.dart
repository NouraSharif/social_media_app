import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/domain/usecases/toggle_post_like_usecase.dart';
import 'package:social_media_app/features/home/presentation/bloc/post_feed_event.dart';
import 'package:social_media_app/features/home/presentation/bloc/post_feed_state.dart';

import '../../../../core/domain/usecases/get_posts_usecase.dart';

class PostFeedBloc extends Bloc<PostFeedEvent, PostFeedState> {
  final GetPostsUseCase getPostsUseCase;
  final TogglePostLikeUseCase togglePostLikeUseCase;
  int _loadVersion = 0;

  PostFeedBloc({
    required this.togglePostLikeUseCase,
    required this.getPostsUseCase,
  }) : super(const PostFeedState()) {
    on<PostFeedRequested>(_onRequested);
    on<PostFeedLikeToggled>(_onLikeToggled);
  }

  Future<void> _onRequested(
    PostFeedRequested event,
    Emitter<PostFeedState> emit,
  ) async {
    final version = ++_loadVersion;
    emit(state.copyWith(status: PostFeedStatus.loading));
    try {
      final posts = await getPostsUseCase();
      if (version != _loadVersion) return;
      emit(state.copyWith(status: PostFeedStatus.success, posts: posts));
    } catch (_) {
      if (version != _loadVersion) return;
      emit(
        state.copyWith(
          status: PostFeedStatus.failure,
          errorMessage: 'Could not load posts.',
        ),
      );
    }
  }

  Future<void> _onLikeToggled(
    PostFeedLikeToggled event,
    Emitter<PostFeedState> emit,
  ) async {
    if (state.status != PostFeedStatus.success ||
        state.likingPostIds.contains(event.post.id)) {
      return;
    }
    emit(
      state.copyWith(likingPostIds: {...state.likingPostIds, event.post.id}),
    );
    try {
      final updated = await togglePostLikeUseCase(event.post);
      emit(
        state.copyWith(
          posts: state.posts
              .map((post) => post.id == updated.id ? updated : post)
              .toList(),
          likingPostIds: {...state.likingPostIds}..remove(event.post.id),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          likingPostIds: {...state.likingPostIds}..remove(event.post.id),
          errorMessage: 'Could not update like. Check your connection and sign-in, then try again.',
        ),
      );
    }
    // If navigation started a load during this write, load again after it commits.
    if (state.status == PostFeedStatus.loading) add(const PostFeedRequested());
  }
}
