import 'package:flutter/cupertino.dart';

import '../constants/app_colors.dart';
import '../data/profile_avatar_cache.dart';
import '../injection_container.dart';
import '../utils/context_extension.dart';

class AuthorAvatar extends StatefulWidget {
  const AuthorAvatar({
    super.key,
    required this.authorId,
    required this.fallbackUrl,
    required this.size,
  });

  final String authorId;
  final String? fallbackUrl;
  final double size;

  @override
  State<AuthorAvatar> createState() => _AuthorAvatarState();
}

class _AuthorAvatarState extends State<AuthorAvatar> {
  String? _profileUrl;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  @override
  void didUpdateWidget(covariant AuthorAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.authorId != widget.authorId) {
      _profileUrl = null;
      _loadAvatar();
    }
  }

  Future<void> _loadAvatar() async {
    final requestId = ++_requestId;
    if (widget.authorId.trim().isEmpty) return;
    final url = await sl<ProfileAvatarCache>().getAvatarUrl(widget.authorId);
    if (!mounted || requestId != _requestId || url == null || url.isEmpty) {
      return;
    }
    if (_profileUrl != url) {
      setState(() => _profileUrl = url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final url = _profileUrl ?? widget.fallbackUrl?.trim();
    final placeholder = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: const Color(0xFFCED5DC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        CupertinoIcons.person_fill,
        color: const Color(0xFF9397A8),
        size: context.w(22),
      ),
    );

    return Container(
      width: widget.size,
      height: widget.size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: url == null || url.isEmpty
          ? placeholder
          : Image.network(
              url,
              key: ValueKey(url),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => placeholder,
            ),
    );
  }
}
