import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../domain/entities/post_entity.dart';
import '../domain/usecases/delete_post_usecase.dart';
import '../injection_container.dart';

class PostDeleteMenu extends StatelessWidget {
  final PostEntity post;
  final Widget icon;
  final VoidCallback? onDeleted;

  const PostDeleteMenu({
    super.key,
    required this.post,
    required this.icon,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid != post.authorId || onDeleted == null) return icon;

    return PopupMenuButton<String>(
      tooltip: 'Post options',
      padding: EdgeInsets.zero,
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'delete', child: Text('Delete post')),
      ],
      onSelected: (_) async {
        final deleted = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => _DeletePostDialog(postId: post.id),
        );
        if (deleted == true && context.mounted) onDeleted?.call();
      },
      child: icon,
    );
  }
}

class _DeletePostDialog extends StatefulWidget {
  final String postId;
  const _DeletePostDialog({required this.postId});

  @override
  State<_DeletePostDialog> createState() => _DeletePostDialogState();
}

class _DeletePostDialogState extends State<_DeletePostDialog> {
  bool _isDeleting = false;
  String? _error;

  Future<void> _delete() async {
    if (_isDeleting) return;
    setState(() {
      _isDeleting = true;
      _error = null;
    });
    try {
      await sl<DeletePostUseCase>()(widget.postId);
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isDeleting = false;
        _error = 'Could not delete this post. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isDeleting,
      child: AlertDialog(
        title: const Text('Delete post?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This will remove your post. This cannot be undone.'),
            if (_isDeleting) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: _isDeleting
                ? null
                : () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _isDeleting ? null : _delete,
            child: Text(_isDeleting ? 'Deleting…' : 'Delete'),
          ),
        ],
      ),
    );
  }
}
