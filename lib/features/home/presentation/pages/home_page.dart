import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/core/widgets/post_card.dart';
import 'package:social_media_app/core/widgets/app_snack_bar.dart';

import '../bloc/post_feed_bloc.dart';
import '../bloc/post_feed_event.dart';
import '../bloc/post_feed_state.dart';
import '../widgets/u_app_bar.dart';

// صارت HomePage بس UI - الـ Bloc منجيبه من الشجرة (جاي من HomeShell فوقها)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UAppBar(title: 'Feed'),
      body: BlocConsumer<PostFeedBloc, PostFeedState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            AppSnackBar.showError(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case PostFeedStatus.initial:
            case PostFeedStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case PostFeedStatus.failure:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Could not load posts. Please try again.'),
                    TextButton(
                      onPressed: () => context.read<PostFeedBloc>().add(
                        const PostFeedRequested(),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );

            case PostFeedStatus.success:
              if (state.posts.isEmpty) {
                return const Center(
                  child: Text('No posts yet. Create the first one!'),
                );
              }
              return ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (_, index) {
                  final post = state.posts[index];
                  return PostCard(
                    key: ValueKey(post.id),
                    post: post,
                    onDeleted: () {
                      if (!context.mounted) return;
                      AppSnackBar.showSuccess(
                        context,
                        'Post deleted successfully.',
                      );
                      context.read<PostFeedBloc>().add(
                        PostFeedPostDeleted(post.id),
                      );
                    },
                    onLikeTap: state.likingPostIds.contains(post.id)
                        ? null
                        : () {
                            context.read<PostFeedBloc>().add(
                              PostFeedLikeToggled(post),
                            );
                          },
                    onTap: () async {
                      final deleted = await context.push<bool>(
                        AppRoutes.postDetailsPath(post.id),
                      );
                      if (context.mounted) {
                        if (deleted == true) {
                          AppSnackBar.showSuccess(
                            context,
                            'Post deleted successfully.',
                          );
                          context.read<PostFeedBloc>().add(
                            PostFeedPostDeleted(post.id),
                          );
                        }
                        context.read<PostFeedBloc>().add(
                          const PostFeedRequested(),
                        );
                      }
                    },
                  );
                },
              );
          }
        },
      ),
    );
  }
}
