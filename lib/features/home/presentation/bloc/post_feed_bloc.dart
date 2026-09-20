import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/domain/usecases/toggle_post_like_usecase.dart';
import 'package:social_media_app/features/home/presentation/bloc/post_feed_event.dart';
import 'package:social_media_app/features/home/presentation/bloc/post_feed_state.dart';

import '../../../../core/domain/usecases/get_posts_usecase.dart';

class PostFeedBloc extends Bloc<PostFeedEvent , PostFeedState> {
  final GetPostsUseCase getPostsUseCase;
  final TogglePostLikeUseCase togglePostLikeUseCase;

  PostFeedBloc({
    required this.togglePostLikeUseCase,
    required this.getPostsUseCase,
}): super(const PostFeedState()){
    on<PostFeedRequested>(_onRequested);
    on<PostFeedLikeToggled>(_onLikeToggled);
  }

  Future<void> _onRequested(
      PostFeedRequested event,
      Emitter<PostFeedState> emit,
      ) async {
    emit(state.copyWith(status: PostFeedStatus.loading));
    try{
      final posts = await getPostsUseCase();
      emit(state.copyWith(status: PostFeedStatus.success, posts: posts));
    } catch (e){
      emit(state.copyWith(status: PostFeedStatus.failure, errorMessage: e.toString()));
    }
  }
  
  Future<void> _onLikeToggled(
      PostFeedLikeToggled event,
      Emitter<PostFeedState> emit,
      ) async {
    final optimisticPosts = state.posts.map((p){
      if(p.id != event.post.id) return p;
      final newIsLiked = !p.isLiked;
      return p.copyWith(
        isLiked: newIsLiked,
        likesCount: newIsLiked ? p.likesCount + 1 : p.likesCount -1
      );
    }).toList();
    
    emit(state.copyWith(posts: optimisticPosts));
    try{
      final updated = await togglePostLikeUseCase(event.post);
      final syncedPosts = state.posts
      .map((p)=> p.id == updated.id ? updated :p).toList();
      emit(state.copyWith(posts: syncedPosts));
    } catch (e){
      final rolledBack = state.posts
          .map((p)=> p.id == event.post.id ? event.post :p).toList();
      emit(state.copyWith(posts: rolledBack));
    }
  }

}