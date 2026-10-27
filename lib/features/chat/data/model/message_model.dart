import 'package:social_media_app/features/chat/domain/entities/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.senderId,
    required super.receiverId,
    required super.text,
    required super.image,
    required super.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final timestamp = json['timestamp'];

    return MessageModel(
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      text: json['text'] as String,
      image: json['image'] as String?,
      timestamp: timestamp is Timestamp ? timestamp.toDate() : null,
    );
  }
}
