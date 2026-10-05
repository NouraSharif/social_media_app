import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/core/widgets/post_card.dart';

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
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
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
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return PostCard(
                    post: post,
                    onLikeTap: state.likingPostIds.contains(post.id)
                        ? null
                        : () {
                            context.read<PostFeedBloc>().add(
                              PostFeedLikeToggled(post),
                            );
                          },
                    onTap: () async {
                      await context.push(AppRoutes.postDetailsPath(post.id));
                      if (context.mounted) {
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
