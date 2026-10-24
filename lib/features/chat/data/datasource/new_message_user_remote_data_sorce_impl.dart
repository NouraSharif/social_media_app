import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/chat/data/datasource/new_message_user_remote_data_sorce.dart';
import 'package:social_media_app/features/chat/data/model/new_message_user_model.dart';

class NewMessageUserRemoteDataSorceImpl
    implements NewMessageUserRemoteDataSorce {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  const NewMessageUserRemoteDataSorceImpl(this._firebaseAuth, this._firestore);
  @override
  Stream<List<NewMessageUserModel>> getNewMessageUsers() {
    //This code is temporary
    //users based on follow/follower relationships.
    final currentUserId = _firebaseAuth.currentUser?.uid;

    if (currentUserId == null) {
      return Stream.error(Exception('User is not authenticated'));
    }

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final chats = await Future.wait(
            snapshot.docs.map((doc) async {
              final data = doc.data();
              final hiddenFor = List<String>.from(data['hiddenFor'] ?? []);

              if (hiddenFor.contains(currentUserId)) {
                return null;
              }

              final participants = List<String>.from(
                data['participants'] ?? [],
              );

              final otherUsers = participants
                  .where((id) => id != currentUserId)
                  .toList();

              if (otherUsers.length != 1) {
                return null;
              }

              final otherUserId = otherUsers.first;

              final profileSnapshot = await _firestore
                  .collection('profiles')
                  .doc(otherUserId)
                  .get();

              final profileData = profileSnapshot.data() ?? <String, dynamic>{};

              return NewMessageUserModel.fromJson({
                'chatId': doc.id,
                'otherUserId': otherUserId,
                'displayName': profileData['displayName'] ?? 'Unknown user',
                'username': profileData['username'] ?? 'Unknown user',
                'image': profileData['profileImageUrl'],
                'lastMessage': data['lastMessage'],
                'lastMessageAt': data['lastMessageAt'],
                'lastMessageSenderId': data['lastMessageSenderId'],
              });
            }),
          );

          return chats.whereType<NewMessageUserModel>().toList();
        });
  }

  @override
  Future<List<NewMessageUserModel>> searchUsers(String searchText) async {
    final query = searchText.trim().toLowerCase();
    if (query.isEmpty) return [];

    // اليوزر نيم مخزن مع @، فنضيفها لو المستخدم ما كتبها
    final usernameQuery = query.startsWith('@') ? query : '@$query';

    final profiles = _firestore.collection('profiles');

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
    final Map<String, NewMessageUserModel> unique = {};

    for (final snapshot in results) {
      for (final doc in snapshot.docs) {
        final data = doc.data();

        unique[doc.id] = NewMessageUserModel.fromJson({
          ...data,
          'otherUserId': doc.id,
          'chatId': '',
          'image': data['profileImageUrl'],
        });
      }
    }

    // استثناء المستخدم الحالي من النتائج
    final currentUid = _firebaseAuth.currentUser?.uid;
    if (currentUid != null) {
      unique.remove(currentUid);
    }

    return unique.values.toList();
  }
}
