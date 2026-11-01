import 'package:cloud_firestore/cloud_firestore.dart';

/// Shares profile avatar lookups across posts and comments, including nulls.
class ProfileAvatarCache {
  ProfileAvatarCache(this._firestore);

  final FirebaseFirestore _firestore;
  static const _lifetime = Duration(minutes: 10);
  final _cache = <String, ({String? url, DateTime expiresAt})>{};
  final _inFlight = <String, Future<String?>>{};
  int _generation = 0;

  Future<String?> getAvatarUrl(String authorId) {
    final uid = authorId.trim();
    if (uid.isEmpty) return Future.value(null);

    final cached = _cache[uid];
    if (cached != null && DateTime.now().isBefore(cached.expiresAt)) {
      return Future.value(cached.url);
    }
    _cache.remove(uid);
    return _inFlight.putIfAbsent(uid, () {
      final generation = _generation;
      // Register the future before starting work, including synchronous errors.
      return Future<String?>.microtask(() => _fetch(uid, generation));
    });
  }

  Future<String?> _fetch(String uid, int generation) async {
    String? url;
    try {
      // Do not treat a stale Firestore disk-cache value as a current profile.
      final document = await _firestore
          .collection('profiles')
          .doc(uid)
          .get(const GetOptions(source: Source.server));
      final value = document.data()?['profileImageUrl'];
      if (value is String && value.trim().isNotEmpty) {
        url = value.trim();
      }
    } catch (_) {
      // Missing access, connectivity, or invalid data must not break the feed.
      url = null;
    }

    _inFlight.remove(uid);
    if (generation != _generation) return null;
    _cache[uid] = (url: url, expiresAt: DateTime.now().add(_lifetime));
    return url;
  }

  void clear() {
    _generation++;
    _cache.clear();
    // Keep pending requests deduplicated, but discard their eventual results.
  }
}
