import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/chat/domain/entities/chat.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required super.chatId,
    required super.otherUserId,
    required super.image,
    required super.displayName,
    required super.userName,
    required super.lastMessage,
    required super.lastMessageAt,
    required super.lastMessageSenderId,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final timestamp = json['lastMessageAt'];

    return ChatModel(
      chatId: json['chatId'] as String,
      otherUserId: json['otherUserId'] as String,
      image: json['image'] as String?,
      displayName: json['displayName'] as String? ?? 'Unknown user',
      userName: json['userName'] as String? ?? 'Unknown user',
      lastMessage: json['lastMessage'] as String? ?? '',
      lastMessageAt: timestamp is Timestamp
          ? timestamp.toDate()
          : timestamp is DateTime
          ? timestamp
          : null,
      lastMessageSenderId: json['lastMessageSenderId'] as String? ?? '',
    );
  }
}
