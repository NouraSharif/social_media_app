import 'package:equatable/equatable.dart';
import 'package:social_media_app/core/domain/entities/post_entity.dart';

sealed class PostFeedEvent extends Equatable{
  const PostFeedEvent();

  @override
  List<Object?> get props =>[];
}

class PostFeedRequested extends PostFeedEvent{
  const PostFeedRequested();
}
class PostFeedLikeToggled extends PostFeedEvent{
  final PostEntity post;
  const PostFeedLikeToggled(this.post);

  List<Object?> get props => [post];

}
