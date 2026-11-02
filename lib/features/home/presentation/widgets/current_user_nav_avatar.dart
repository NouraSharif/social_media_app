import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/data/profile_avatar_cache.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/utils/context_extension.dart';

class CurrentUserNavAvatar extends StatefulWidget {
  const CurrentUserNavAvatar({super.key, required this.isSelected});

  final bool isSelected;

  @override
  State<CurrentUserNavAvatar> createState() => _CurrentUserNavAvatarState();
}

class _CurrentUserNavAvatarState extends State<CurrentUserNavAvatar> {
  late final StreamSubscription<User?> _authSubscription;
  String? _uid;
  String? _url;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _uid = firebaseAuth.currentUser?.uid;
    _loadAvatar();
    _authSubscription = firebaseAuth.authStateChanges().listen((user) {
      if (!mounted || user?.uid == _uid) return;
      setState(() {
        _uid = user?.uid;
        _url = null;
      });
      _loadAvatar();
    });
  }

  Future<void> _loadAvatar() async {
    final requestId = ++_requestId;
    final uid = _uid;
    if (uid == null || uid.trim().isEmpty) return;

    String? url;
    try {
      url = (await sl<ProfileAvatarCache>().getAvatarUrl(uid))?.trim();
    } catch (_) {
      // A failed lookup uses the same fallback as a missing profile photo.
      url = null;
    }
    if (!mounted ||
        requestId != _requestId ||
        uid != _uid ||
        uid != firebaseAuth.currentUser?.uid) {
      return;
    }
    setState(() => _url = url == null || url.isEmpty ? null : url);
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = context.w(24).clamp(20.0, 28.0).toDouble();
    final ringWidth = context.w(1.5).clamp(1.0, 2.0).toDouble();
    final fallback = Icon(
      CupertinoIcons.person_circle_fill,
      size: size - ringWidth * 2,
      color: widget.isSelected ? AppColors.black : AppColors.secondaryIconColor,
    );
    final url = _url;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: ringWidth,
          color: widget.isSelected
              ? AppColors.primary
              : const Color(0x00000000),
        ),
      ),
      child: ClipOval(
        child: url == null
            ? fallback
            : Image.network(
                url,
                key: ValueKey((_uid, url)),
                width: size,
                height: size,
                fit: BoxFit.cover,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return wasSynchronouslyLoaded || frame != null
                      ? child
                      : fallback;
                },
                errorBuilder: (context, error, stackTrace) => fallback,
              ),
      ),
    );
  }
}
