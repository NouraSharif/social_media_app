import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/widgets/second_appbar.dart';
import 'package:social_media_app/features/home/presentation/widgets/post_card.dart';
import 'package:social_media_app/features/post_details/presentation/model/comment_model.dart';
import 'package:social_media_app/features/post_details/presentation/widgets/comment_card.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/context_extension.dart';
import '../../../home/presentation/model/post_model.dart';

class PostDetailsPage extends StatefulWidget {
  final String postId;

  const PostDetailsPage({super.key, required this.postId});

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  late List<Comment> _comments ;
  final TextEditingController _commentController = TextEditingController();
  Post? _post;

  @override
  void initState() {
    super.initState();
    _loadPost();
    _loadComments();
    _commentController.addListener(()=> setState(() {

    }));

  }
  void _loadPost() {
      _post = mockPosts.cast<Post?>().firstWhere(
            (post) => post?.id == widget.postId,
        orElse: () => null,
      );
  }

  void _loadComments() {
    _comments = mockComments
        .where((comment) => comment.postId == widget.postId)
        .toList();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleLike(Comment comment) {
    setState(() {
      comment.isLiked = !comment.isLiked;
      comment.likesCount += comment.isLiked ? 1 : -1;
    });
  }

  void _handleSendComment() {
    final commentText = _commentController.text.trim();
    if (commentText.isNotEmpty) {
      setState(() {
        _comments.add(Comment(
          id: DateTime.now().toString(),
          userName: 'Current User',
          userAvatarUrl: null,
          content: commentText,
          likesCount: 0,
          isLiked: false,
          postId: widget.postId,
          timeAgo: 'Just now',
        ));
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_post ==null){
      return Scaffold(
        appBar: SecondAppbar(title: 'not found'),
        body: Center(
          child: Text('Post not found', style: AppTextStyles.body.copyWith(fontSize: context.sp(16)),),
        ),
      );
    }
    return Scaffold(
      appBar: SecondAppbar(title: '${_post!.userName}\'s Post'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                PostCard(
                  post: mockPosts.firstWhere(
                    (post) => post.id == widget.postId,
                  ),
                  onLikeTap: () {
                    setState(() {
                      final post = mockPosts.firstWhere(
                        (post) => post.id == widget.postId,
                      );
                      post.isLiked = !post.isLiked;
                      post.likesCount += post.isLiked ? 1 : -1;
                    });
                  },
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    final comment = _comments[index];
                    return CommentCard(
                      comment: comment,
                      onLikeTap: () => _toggleLike(comment),
                    );
                  },
                ),
              ],
            ),
          ),
          CommentBar(
            controller: _commentController,
            onSend: _handleSendComment,
            isEnabled: _commentController.text.trim().isNotEmpty,
          onGalleryTap: (){} ,),
        ],
      ),
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
