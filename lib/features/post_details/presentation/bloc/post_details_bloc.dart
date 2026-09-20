import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/domain/usecases/get_post_by_id_usecase.dart';
import 'package:social_media_app/core/domain/usecases/toggle_post_like_usecase.dart';
import 'package:social_media_app/features/post_details/domain/entities/comment_entity.dart';
import 'package:social_media_app/features/post_details/domain/usecases/add_comment_usecase.dart';
import 'package:social_media_app/features/post_details/domain/usecases/get_comments_usecase.dart';
import 'package:social_media_app/features/post_details/domain/usecases/toggle_comment_like_usecase.dart';
import 'package:social_media_app/features/post_details/presentation/bloc/post_details_event.dart';
import 'package:social_media_app/features/post_details/presentation/bloc/post_details_state.dart';

class PostDetailsBloc extends Bloc<PostDetailsEvent, PostDetailsState>{
  final GetPostByIdUseCase getPostByIdUseCase;
  final TogglePostLikeUseCase togglePostLikeUseCase;
  final GetCommentsUseCase getCommentsUseCase;
  final AddCommentUseCase addCommentUseCase;
  final ToggleCommentLikeUseCase toggleCommentLikeUseCase;

  late String _postId;

  PostDetailsBloc({
    required this.getPostByIdUseCase,
    required this.togglePostLikeUseCase,
    required this.getCommentsUseCase,
    required this.addCommentUseCase,
    required this.toggleCommentLikeUseCase
}) : super(const PostDetailsState()){
    on<PostDetailsRequested>(_onRequested);
    on<PostDetailsPostLikeToggled>(_onPostLikeToggled);
    on<PostDetailsCommentLikeToggled>(_onCommentLikeToggled);
    on<PostDetailsCommentSubmitted>(_onCommentSubmitted);
  }

  Future<void> _onRequested(
      PostDetailsRequested event,
      Emitter<PostDetailsState>  emit,
      ) async{
    _postId = event.postId;
    emit(state.copyWith(
      status: PostDetailsStatus.loading,));
    try{
      final post = await getPostByIdUseCase(event.postId);
      final comments = await getCommentsUseCase(event.postId);
      emit(state.copyWith(
        status: PostDetailsStatus.success,
        post: post,
        comments: comments
      ));
    } catch (e){
      emit(state.copyWith(
        status: PostDetailsStatus.notFound,
        errorMessage: e.toString()
      ));
    }
  }

  Future<void> _onPostLikeToggled(
      PostDetailsPostLikeToggled event,
      Emitter<PostDetailsState> emit
      ) async{
     final newIsLiked= !event.post.isLiked;
     final optimistic = event.post.copyWith(
       isLiked: newIsLiked,
       likesCount: newIsLiked? event.post.likesCount+1 :event.post.likesCount - 1
     );
     emit(state.copyWith(post: optimistic));

     try{
       final updated = await togglePostLikeUseCase(event.post);
       emit(state.copyWith(post: updated));
     } catch(e){
       emit(state.copyWith(
         post: event.post,
         errorMessage: 'failed'
       ));
     }
  }

  Future<void> _onCommentLikeToggled(
      PostDetailsCommentLikeToggled event,
      Emitter<PostDetailsState> emit) async {
    final newIsLiked = !event.comment.isLiked;
    final optimisticComments = state.comments.map((c){
      if(c.id!=event.comment.id)return c;
      return c.copyWith(
        isLiked: newIsLiked,
        likesCount: newIsLiked ? c.likesCount + 1 : c.likesCount - 1,
      );
    }).toList();
    emit(state.copyWith(comments: optimisticComments));

    try{
      final updated = await toggleCommentLikeUseCase(event.comment);
       emit(
           state.copyWith(
         comments: state.comments
             .map((c)=> c.id == updated.id? updated :c).toList()
       ));
    } catch (e) {
      emit(state.copyWith(
        comments: state.comments
            .map((c) => c.id == event.comment.id ? event.comment : c)
            .toList(),
      ));
    
    }

  }

  Future<void> _onCommentSubmitted(
      PostDetailsCommentSubmitted event,
      Emitter<PostDetailsState> emit,
      ) async {
    final text = event.content.trim();
    if(text.isEmpty) return;

    final tempComment = CommentEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postId: _postId,
        userName: 'you',
        timeAgo: 'just now',
        content: text);
    emit(state.copyWith(
      comments: [tempComment,...state.comments]
    ));

    try{
      final saved = await addCommentUseCase(tempComment);
      emit(state.copyWith(
        comments: [saved, ...state.comments.where((c)=> c.id != tempComment.id)]
      ));
    } catch (e){
      emit(state.copyWith(
        comments: state.comments.where((c)=> c.id != tempComment.id).toList(),
        errorMessage: 'failed to send comment'
      ));
    }
  }



}