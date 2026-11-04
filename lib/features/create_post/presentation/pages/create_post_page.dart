import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';
import 'package:social_media_app/core/widgets/second_appbar.dart';
import 'package:social_media_app/core/widgets/app_snack_bar.dart';

import '../../../../core/injection_container.dart';
import '../../domain/usecases/create_post_usecase.dart';
import '../bloc/create_post_bloc.dart';
import '../bloc/create_post_event.dart';
import '../bloc/create_post_state.dart';
import '../widgets/category_selector_tile.dart';
import '../widgets/photo_picker_row.dart';
import '../widgets/post_action_bar.dart';
import '../widgets/selected_photo_previews.dart';

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
  final Map<String, Directory> _suggestionDirectories = {};

  String _suggestionPath(Directory directory) =>
      '${directory.path}${Platform.pathSeparator}suggestion.jpg';

  Future<void> _deleteSuggestionDirectory(Directory directory) async {
    try {
      final file = File(_suggestionPath(directory));
      if (await file.exists()) await file.delete();
      // Only remove the directory created for this suggestion, never recursively.
      await directory.delete();
    } catch (_) {
      // Best-effort cleanup must not interrupt editing or successful posting.
    }
  }

  Future<void> _selectSuggestion(String asset) async {
    if (_isPicking || _suggestionDirectories.containsKey(asset)) return;
    final bloc = context.read<CreatePostBloc>();
    if (bloc.state.submissionStatus == CreatePostSubmissionStatus.submitting ||
        bloc.state.submissionStatus == CreatePostSubmissionStatus.success) {
      return;
    }
    if (kIsWeb) {
      AppSnackBar.showWarning(
        context,
        "Adding photos isn't supported on web yet.",
      );
      return;
    }
    setState(() => _isPicking = true);
    Directory? directory;
    var attached = false;
    try {
      final data = await rootBundle.load(asset);
      directory = await Directory.systemTemp.createTemp('post_suggestion_');
      final path = _suggestionPath(directory);
      await File(path).writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        flush: true,
      );
      if (!mounted || bloc.isClosed) return;
      if (bloc.state.submissionStatus == CreatePostSubmissionStatus.submitting ||
          bloc.state.submissionStatus == CreatePostSubmissionStatus.success) {
        return;
      }
      _suggestionDirectories[asset] = directory;
      // Keep picking locked until the existing bloc has accepted the path.
      final applied = bloc.stream.firstWhere(
        (state) => state.imagePaths.contains(path),
      );
      bloc.add(CreatePostImagesChanged([...bloc.state.imagePaths, path]));
      await applied;
      attached = mounted;
    } catch (_) {
      if (mounted) {
        _suggestionDirectories.remove(asset);
        AppSnackBar.showError(context, 'Could not add this photo. Try again.');
      }
    } finally {
      if (!attached && directory != null) {
        await _deleteSuggestionDirectory(directory);
      }
      if (mounted) setState(() => _isPicking = false);
    }
  }

  void _removePhoto(int index) {
    final bloc = context.read<CreatePostBloc>();
    if (_isPicking ||
        bloc.state.submissionStatus == CreatePostSubmissionStatus.submitting) {
      return;
    }
    final paths = [...bloc.state.imagePaths];
    if (index < 0 || index >= paths.length) return;
    final removed = paths.removeAt(index);
    bloc.add(CreatePostImagesChanged(paths));
    for (final entry in _suggestionDirectories.entries.toList()) {
      if (_suggestionPath(entry.value) == removed) {
        setState(() => _suggestionDirectories.remove(entry.key));
        unawaited(_deleteSuggestionDirectory(entry.value));
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _postFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    for (final directory in _suggestionDirectories.values) {
      unawaited(_deleteSuggestionDirectory(directory));
    }
    _suggestionDirectories.clear();
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
        AppSnackBar.showError(
          context,
          'Could not open the image picker. Check photo/camera permissions and try again.',
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
            if (context.mounted) context.pop(true);
          });
        } else if (state.submissionStatus ==
            CreatePostSubmissionStatus.failure) {
          AppSnackBar.showError(context, state.errorMessage ?? 'error');
        }
      },
      builder: (context, state) {
        final bloc = context.read<CreatePostBloc>();
        final isSubmitting =
            state.submissionStatus == CreatePostSubmissionStatus.submitting;

        return PopScope(
          canPop: !isSubmitting,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
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
                          vertical: context.h(16).clamp(12.0, 24.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.w(16).clamp(12.0, 24.0),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(
                                  context.w(12).clamp(8.0, 16.0),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.border),
                                  borderRadius: BorderRadius.circular(
                                    context.w(8).clamp(6.0, 12.0),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    if (state.imagePaths.isNotEmpty) ...[
                                      SelectedPhotoPreviews(
                                        imagePaths: state.imagePaths,
                                        onRemove: _removePhoto,
                                      ),
                                      SizedBox(
                                        height: context.h(12).clamp(8.0, 16.0),
                                      ),
                                    ],
                                    TextFormField(
                                      controller: _postController,
                                      focusNode: _postFocusNode,
                                      maxLines: null,
                                      minLines: 6,
                                      textInputAction: TextInputAction.newline,
                                      onChanged: (value) => bloc.add(
                                        CreatePostContentChanged(value),
                                      ),
                                      style: AppTextStyles.textField.copyWith(
                                        fontSize: context
                                            .sp(16)
                                            .clamp(14.0, 20.0),
                                        height: 1.4,
                                      ),
                                      decoration: InputDecoration(
                                        filled: false,
                                        hintText: 'Tell your audience more..',
                                        hintStyle: AppTextStyles.textField
                                            .copyWith(
                                              fontSize: context
                                                  .sp(16)
                                                  .clamp(14.0, 20.0),
                                              color: AppColors.textSecondary,
                                            ),
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: context.h(16).clamp(12.0, 24.0)),
                            CategorySelectorTile(
                              label: state.category,
                              onTap: () {},
                            ),
                            SizedBox(height: context.h(12).clamp(8.0, 16.0)),
                            PhotoPickerRow(
                              selectedSuggestions: _suggestionDirectories.keys
                                  .toSet(),
                              onSuggestionTap: _selectSuggestion,
                              onAddPhotoTap: _handleAddPhoto,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: context.h(20).clamp(16.0, 28.0),
                      color: AppColors.border,
                    ),
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
