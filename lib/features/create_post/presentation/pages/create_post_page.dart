import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';

import '../../../../core/widgets/second_appbar.dart';
import '../widgets/category_selector_tile.dart';
import '../widgets/photo_picker_row.dart';
import '../widgets/post_action_bar.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _postController = TextEditingController();
  final FocusNode _postFocusNode = FocusNode();

  int? _selectedPhotoIndex;
  String _selectedCategory = 'Chasing';

  final List<String> _mockGalleryImages = [
    'https://images.unsplash.com/photo-1441974231531-c6227db76b6e',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9',
    'https://images.unsplash.com/photo-1500534623283-312aade485b7',
    'https://images.unsplash.com/photo-1519681393784-d120267933ba',
  ];

  bool get _canPost =>
      _postController.text.trim().isNotEmpty || _selectedPhotoIndex != null;

  @override
  void initState() {
    super.initState();
    _postController.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _postFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _postController.dispose();
    _postFocusNode.dispose();
    super.dispose();
  }

  void _handleAddPhoto() {
    showAddPhotoSheet(
      context: context,
      onTakePicture: () {
      },
      onUploadFromGallery: () {
      },
    );
  }

  void _handleCategoryTap() {
  }

  void _handlePost() {
    if (!_canPost) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondAppbar(title: 'New Post',),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(5),
                  vertical: context.h(16),
                ),
                child: TextFormField(
                  controller: _postController,
                  focusNode: _postFocusNode,
                  maxLines: null,
                  minLines: 6,
                  textInputAction: TextInputAction.newline,
                  style: AppTextStyles.textField.copyWith(
                    fontSize: context.sp(16),
                    height: 1.4,
                  ),
                  decoration: InputDecoration(
                    filled: false,
                    hintText: 'Tell your audience more..',
                    hintStyle: AppTextStyles.textField.copyWith(
                      fontSize: context.sp(16),
                      color: AppColors.textSecondary,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(context.w(8)),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            CategorySelectorTile(
              label: _selectedCategory,
              onTap: _handleCategoryTap,
            ),
            SizedBox(height: context.h(12)),
            PhotoPickerRow(
              imagePaths: _mockGalleryImages,
              selectedIndex: _selectedPhotoIndex,
              onAddPhotoTap: _handleAddPhoto,
              onPhotoSelected: (index) {
                setState(() {
                  _selectedPhotoIndex =
                      _selectedPhotoIndex == index ? null : index;
                });
              },
            ),
            Divider(height: context.h(20), color: AppColors.border),
            PostActionBar(
              isEnabled: _canPost,
              onGalleryTap: _handleAddPhoto,
              onGifTap: () {
              },
              onPostTap: _handlePost,
            ),

          ],
        ),
      ),
    );
  }


}


