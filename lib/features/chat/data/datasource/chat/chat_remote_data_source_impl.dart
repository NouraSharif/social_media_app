import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/chat/data/datasource/chat/chat_remote_data_source.dart';
import 'package:social_media_app/features/chat/data/model/message_model.dart';
import 'package:social_media_app/features/chat/domain/entities/message.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  const ChatRemoteDataSourceImpl(this._firestore, this._auth);

  @override
  Future<void> sendMessage(Message message) async {
    final currentUserId = _auth.currentUser?.uid;

    if (currentUserId == null) {
      throw Exception('User is not authenticated');
    }

    if (currentUserId == message.receiverId) {
      throw Exception('You cannot send a message to yourself');
    }

    final participants = [currentUserId, message.receiverId]..sort();

    try {
      final chatQuery = await _firestore
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .get();

      final matchingChat = chatQuery.docs.where((doc) {
        final chatParticipants = List<String>.from(
          doc.data()['participants'] ?? [],
        );

        return chatParticipants.length == 2 &&
            chatParticipants.contains(message.receiverId);
      }).firstOrNull;

      final isNewChat = matchingChat == null;

      final chatRef =
          matchingChat?.reference ?? _firestore.collection('chats').doc();

      final messageRef = chatRef.collection('messages').doc();
      final batch = _firestore.batch();
      final timestamp = FieldValue.serverTimestamp();

      // Save the message.
      batch.set(messageRef, {
        'senderId': currentUserId,
        'receiverId': message.receiverId,
        'text': message.text,
        'image': message.image,
        'timestamp': timestamp,
      });

      if (isNewChat) {
        // Create the chat when the first message is sent.
        batch.set(chatRef, {
          'participants': participants,
          'createdAt': timestamp,
          'lastMessage': message.text,
          'lastMessageAt': timestamp,
          'lastMessageSenderId': currentUserId,
          'hiddenFor': <String>[],
        });
      } else {
        // Update the existing chat and make it visible to both users again.
        batch.update(chatRef, {
          'lastMessage': message.text,
          'lastMessageAt': timestamp,
          'lastMessageSenderId': currentUserId,
          'hiddenFor': FieldValue.arrayRemove([
            currentUserId,
            message.receiverId,
          ]),
        });
      }

      await batch.commit();
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Stream<List<Message>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshots) => snapshots.docs
              .map((doc) => MessageModel.fromJson(doc.data()))
              .toList(),
        );
  }
}
