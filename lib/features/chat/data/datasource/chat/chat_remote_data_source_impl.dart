import 'dart:convert';

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

      final chatId = base64Url.encode(utf8.encode(participants.join('|')));

      final chatRef =
          matchingChat?.reference ?? _firestore.collection('chats').doc(chatId);
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
          'hasMessages': true,
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
          'hasMessages': true,
        });
      }

      await batch.commit();
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Stream<List<Message>> getMessages(String chatId) {
    final chatRef = _firestore.collection('chats').doc(chatId);

    return chatRef.snapshots().asyncExpand((chatSnapshot) {
      if (!chatSnapshot.exists) {
        return Stream.value(<Message>[]);
      }

      return chatRef
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => MessageModel.fromJson(doc.data()))
                .toList(),
          );
    });
  }

  @override
  Future<String> getOrCreateChat(String otherUserId) async {
    final currentUserId = _auth.currentUser?.uid;

    if (currentUserId == null) {
      throw Exception('User is not authenticated');
    }

    if (currentUserId == otherUserId) {
      throw Exception('You cannot chat with yourself');
    }

    final participants = [currentUserId, otherUserId]..sort();

    // Search for an existing conversation.
    final snapshot = await _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .get();

    final existingChat = snapshot.docs.where((doc) {
      final ids = List<String>.from(doc.data()['participants'] ?? []);

      return ids.length == 2 &&
          ids.contains(currentUserId) &&
          ids.contains(otherUserId);
    }).firstOrNull;

    if (existingChat != null) {
      return existingChat.id;
    }

    // Return the deterministic ID without creating an empty chat.
    return base64Url.encode(utf8.encode(participants.join('|')));
  }
}
