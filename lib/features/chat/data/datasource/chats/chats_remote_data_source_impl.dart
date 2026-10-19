import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/chat/data/datasource/chats/chats_remote_data_source.dart';
import 'package:social_media_app/features/chat/data/model/chat_model.dart';

class ChatsRemoteDataSourceImpl implements ChatsRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  ChatsRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  @override
  Stream<List<ChatModel>> getChats() {
    final currentUserId = _firebaseAuth.currentUser?.uid;

    if (currentUserId == null) {
      return Stream.error(Exception('User is not authenticated'));
    }

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
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

              return ChatModel.fromJson({
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

          return chats.whereType<ChatModel>().toList();
        });
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final currentUserId = _firebaseAuth.currentUser?.uid;

    if (currentUserId == null) {
      throw Exception('User is not authenticated');
    }

    final chatRef = _firestore.collection('chats').doc(chatId);

    await chatRef.update({
      'hiddenFor': FieldValue.arrayUnion([currentUserId]),
    });
  }
}
