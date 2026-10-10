import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/chat/data/datasource/chat_remote_data_source.dart';
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

    final participants = [currentUserId, message.receiverId]..sort();

    final chatQuery = await _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .get();

    final matchingChats = chatQuery.docs.where((doc) {
      final chatParticipants = List<String>.from(
        doc.data()['participants'] ?? [],
      );
      return chatParticipants.length == 2 &&
          chatParticipants.contains(message.receiverId);
    }).toList();

    late final String chatId;

    if (matchingChats.isNotEmpty) {
      chatId = matchingChats.first.id;
    } else {
      final chatRef = _firestore.collection('chats').doc();

      await chatRef.set({
        'participants': participants,
        'createdAt': FieldValue.serverTimestamp(),
      });

      chatId = chatRef.id;
    }

    await _firestore.collection('chats').doc(chatId).collection('messages').add(
      {
        'senderId': currentUserId,
        'receiverId': message.receiverId,
        'text': message.text,
        'image': message.image,
        'timestamp': FieldValue.serverTimestamp(),
      },
    );
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

  //   Future<void> deleteAllMessages(String chatId) async {
  //   final messagesRef = _firestore
  //       .collection('chats')
  //       .doc(chatId)
  //       .collection('messages');

  //   final snapshot = await messagesRef.get();

  //   for (var i = 0; i < snapshot.docs.length; i += 500) {
  //     final batch = _firestore.batch();

  //     final docs = snapshot.docs.skip(i).take(500);

  //     for (final doc in docs) {
  //       batch.delete(doc.reference);
  //     }

  //     await batch.commit();
  //   }
  // }
}
