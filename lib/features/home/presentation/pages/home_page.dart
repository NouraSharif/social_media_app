import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';

import '../model/post_model.dart';
import '../widgets/post_card.dart';
import '../widgets/u_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Post> _posts = mockPosts;

  void _toggleLike(Post post) {
    setState(() {
      post.isLiked = !post.isLiked;
      post.likesCount += post.isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UAppBar(title: 'Feed',),

      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];

          return PostCard(
            post: post,
            onLikeTap: () => _toggleLike(post),
          );
        },
      ),
    );
  }
}