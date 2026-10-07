import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';
import 'package:social_media_app/core/widgets/second_appbar.dart';

import '../../../../core/injection_container.dart';
import '../../domain/usecases/create_post_usecase.dart';
import '../bloc/create_post_bloc.dart';
import '../bloc/create_post_event.dart';
import '../bloc/create_post_state.dart';
import '../widgets/category_selector_tile.dart';
import '../widgets/photo_picker_row.dart';
import '../widgets/post_action_bar.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreatePostBloc(createPostUseCase: sl<CreatePostUseCase>()),
      child: const _CreatePostView(),
    );
  }
}

class _CreatePostView extends StatefulWidget {
  const _CreatePostView();

  @override
  State<_CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<_CreatePostView> {
  final TextEditingController _postController = TextEditingController();
  final FocusNode _postFocusNode = FocusNode();

  final ImagePicker _picker = ImagePicker();
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _postFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _postController.dispose();
    _postFocusNode.dispose();
    super.dispose();
  }

  void _handleAddPhoto() {
    if (_isPicking ||
        context.read<CreatePostBloc>().state.submissionStatus ==
            CreatePostSubmissionStatus.submitting) {
      return;
    }
    showAddPhotoSheet(
      context: context,
      onTakePicture: () => _pickImages(true),
      onUploadFromGallery: () => _pickImages(false),
    );
  }

  Future<void> _pickImages(bool camera) async {
    if (_isPicking ||
        context.read<CreatePostBloc>().state.submissionStatus ==
            CreatePostSubmissionStatus.submitting) {
      return;
    }
    setState(() => _isPicking = true);
    try {
      final List<XFile> images;
      if (camera) {
        final image = await _picker.pickImage(source: ImageSource.camera);
        images = image == null ? [] : [image];
      } else {
        images = await _picker.pickMultiImage();
      }
      if (!mounted) return;
      final bloc = context.read<CreatePostBloc>();
      bloc.add(
        CreatePostImagesChanged([
          ...bloc.state.imagePaths,
          ...images.map((image) => image.path),
        ]),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not open the image picker. Check photo/camera permissions and try again.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state.submissionStatus == CreatePostSubmissionStatus.success) {
          // Let PopScope rebuild with canPop enabled before leaving the form.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) context.pop();
          });
        } else if (state.submissionStatus ==
            CreatePostSubmissionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'error')),
          );
        }
      },
      builder: (context, state) {
        final bloc = context.read<CreatePostBloc>();
        final isSubmitting =
            state.submissionStatus == CreatePostSubmissionStatus.submitting;

        return PopScope(
          canPop: !isSubmitting,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AbsorbPointer(
                absorbing: isSubmitting,
                child: const SecondAppbar(title: 'New Post'),
              ),
            ),
            body: SafeArea(
              child: AbsorbPointer(
                absorbing: isSubmitting || _isPicking,
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
                          onChanged: (value) =>
                              bloc.add(CreatePostContentChanged(value)),
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

                    CategorySelectorTile(label: state.category, onTap: () {}),
                    SizedBox(height: context.h(12)),
                    PhotoPickerRow(
                      imagePaths: state.imagePaths,
                      onAddPhotoTap: _handleAddPhoto,
                      onPhotoSelected: (index) {
                        final paths = [...state.imagePaths]..removeAt(index);
                        bloc.add(CreatePostImagesChanged(paths));
                      },
                    ),
                    Divider(height: context.h(20), color: AppColors.border),
                    PostActionBar(
                      isEnabled: state.canPost && !isSubmitting && !_isPicking,
                      isLoading: isSubmitting,
                      onGalleryTap: _handleAddPhoto,
                      onGifTap: () {
                        // TODO
                      },
                      onPostTap: () => bloc.add(const CreatePostSubmitted()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
