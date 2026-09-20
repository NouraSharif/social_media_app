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
      body: BlocBuilder<PostFeedBloc, PostFeedState>(
        builder: (context, state) {
          switch (state.status) {
            case PostFeedStatus.initial:
            case PostFeedStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case PostFeedStatus.failure:
              return Center(child: Text(state.errorMessage ?? 'حدث خطأ ما'));

            case PostFeedStatus.success:
              return ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return PostCard(
                    post: post,
                    onLikeTap: () =>
                        context.read<PostFeedBloc>().add(PostFeedLikeToggled(post)),
                    onTap: () async {
                      await context.push(AppRoutes.postDetailsPath(post.id));
                      if (context.mounted) {
                        context.read<PostFeedBloc>().add(const PostFeedRequested());
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