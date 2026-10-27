import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/search/data/datasource/search_users_remote_data_source.dart';
import 'package:social_media_app/features/search/data/model/search_user_model.dart';

class SearchUsersRemoteDataSourceImpl implements SearchUsersRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  const SearchUsersRemoteDataSourceImpl(this.firebaseAuth, this.firestore);

  @override
  Future<List<SearchUserModel>> searchUsers(String searchText) async {
    final query = searchText.trim().toLowerCase();
    if (query.isEmpty) return [];

    // اليوزر نيم مخزن مع @، فنضيفها لو المستخدم ما كتبها
    final usernameQuery = query.startsWith('@') ? query : '@$query';

    final profiles = firestore.collection('profiles');

    // كويريين بالتوازي (OR بين اليوزر نيم والديسبلي نيم)
    final results = await Future.wait([
      profiles
          .where('username', isGreaterThanOrEqualTo: usernameQuery)
          .where('username', isLessThan: '$usernameQuery\uf8ff')
          .limit(20)
          .get(),
      profiles
          .where('displayNameLower', isGreaterThanOrEqualTo: query)
          .where('displayNameLower', isLessThan: '$query\uf8ff')
          .limit(20)
          .get(),
    ]);

    // دمج النتائج وإزالة التكرار باستخدام معرّف المستخدم
    final Map<String, SearchUserModel> unique = {};

    for (final snapshot in results) {
      for (final doc in snapshot.docs) {
        final data = doc.data();

        unique[doc.id] = SearchUserModel.fromJson({
          ...data,
          'otherUserId': doc.id,
          'chatId': '',
          'image': data['profileImageUrl'],
        });
      }
    }

    // استثناء المستخدم الحالي من النتائج
    final currentUid = firebaseAuth.currentUser?.uid;
    if (currentUid != null) {
      unique.remove(currentUid);
    }

    return unique.values.toList();
  }
}
