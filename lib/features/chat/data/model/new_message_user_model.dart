import 'package:social_media_app/features/chat/domain/entities/new_message_user.dart';

class NewMessageUserModel extends NewMessageUserEntity {
  NewMessageUserModel({
    required super.chatId,
    required super.otherUserId,
    required super.displayName,
    required super.userName,
    required super.image,
  });

  factory NewMessageUserModel.fromJson(Map<String, dynamic> json) {
    return NewMessageUserModel(
      chatId: json['chatId'],
      otherUserId: json['otherUserId'],
      displayName: json['displayName'],
      userName: json['userName'],
      image: json['image'],
    );
  }
}
