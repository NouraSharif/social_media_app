import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/domain/usecases/get_post_by_id_usecase.dart';
import 'package:social_media_app/core/domain/usecases/toggle_post_like_usecase.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';
import 'package:social_media_app/core/widgets/post_card.dart';
import 'package:social_media_app/core/widgets/second_appbar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/injection_container.dart';
import '../../domain/usecases/get_comments_usecase.dart';
import '../../domain/usecases/add_comment_usecase.dart';
import '../../domain/usecases/toggle_comment_like_usecase.dart';
import '../bloc/post_details_bloc.dart';
import '../bloc/post_details_event.dart';
import '../bloc/post_details_state.dart';
import '../widgets/comment_card.dart';

class PostDetailsPage extends StatelessWidget {
  final String postId;
  const PostDetailsPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostDetailsBloc(
        getPostByIdUseCase: sl<GetPostByIdUseCase>(),
        togglePostLikeUseCase: sl<TogglePostLikeUseCase>(),
        getCommentsUseCase: sl<GetCommentsUseCase>(),
        addCommentUseCase: sl<AddCommentUseCase>(),
        toggleCommentLikeUseCase: sl<ToggleCommentLikeUseCase>(),
      )..add(PostDetailsRequested(postId)),
      child: const _PostDetailsView(),
    );
  }
}

class _PostDetailsView extends StatefulWidget {
  const _PostDetailsView();

  @override
  State<_PostDetailsView> createState() => _PostDetailsViewState();
}

class _PostDetailsViewState extends State<_PostDetailsView> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailsBloc, PostDetailsState>(
      builder: (context, state) {
        if (state.status == PostDetailsStatus.loading ||
            state.status == PostDetailsStatus.initial) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state.status == PostDetailsStatus.notFound || state.post == null) {
          return Scaffold(
            appBar: const SecondAppbar(title: 'Not Found'),
            body: Center(
              child: Text(
                'Post not found',
                style: AppTextStyles.body.copyWith(fontSize: context.sp(16)),
              ),
            ),
          );
        }

        final post = state.post!;

        return Scaffold(
          appBar: SecondAppbar(title: "${post.userName}'s Post"),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    PostCard(
                      post: post,
                      onLikeTap: () => context
                          .read<PostDetailsBloc>()
                          .add(PostDetailsPostLikeToggled(post)),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.comments.length,
                      itemBuilder: (context, index) {
                        final comment = state.comments[index];
                        return CommentCard(
                          comment: comment,
                          onLikeTap: () => context
                              .read<PostDetailsBloc>()
                              .add(PostDetailsCommentLikeToggled(comment)),
                        );
                      },
                    ),
                  ],
                ),
              ),
              CommentBar(
                controller: _commentController,
                isEnabled: _commentController.text.trim().isNotEmpty,
                onSend: () {
                  context.read<PostDetailsBloc>().add(
                    PostDetailsCommentSubmitted(_commentController.text),
                  );
                  _commentController.clear();
                },
                onGalleryTap: () {
                  // TODO
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
class CommentBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onGalleryTap;
  final bool isEnabled;
  const CommentBar({
    super.key,
    required this.controller,
    required this.onSend,
    this.onGalleryTap,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(10),
      ),
      decoration: const BoxDecoration(color: AppColors.white),
      child: SafeArea(
        top: false,
        child: Row(
          spacing: 10,
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                maxLines: null,
                minLines: 1,
                style: AppTextStyles.textField,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  fillColor: Colors.grey.shade100,
                  suffixIcon: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(
                        context.w(8),
                      ),
                    ),
                    child: IconButton(
                      onPressed: onGalleryTap,
                      icon: Icon(
                      CupertinoIcons.photo,
                      color: AppColors.primary,
                      size: context.sp(22),
                    ),
                    ),
                  ),
                  hintText: 'Write your comment ..',
                  hintStyle: AppTextStyles.textField.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            ElevatedButton(
                onPressed:isEnabled? onSend :null,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(context.w(34), context.h(34)),
                  padding: EdgeInsets.zero,
                  backgroundColor: isEnabled ?AppColors.primary : AppColors.primary.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.w(10)),
                  ),
                ),
                child: Icon(
                  CupertinoIcons.paperplane_fill,
                  color: AppColors.white,
                  size: context.sp(20),)),
          ],
        ),
      ),
    );
  }
}
