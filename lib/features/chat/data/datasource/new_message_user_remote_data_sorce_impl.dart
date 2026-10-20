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
                'userName': profileData['username'] ?? 'Unknown user',
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
}
