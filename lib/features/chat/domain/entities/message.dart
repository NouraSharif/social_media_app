import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String senderId;
  final String receiverId;
  final String text;
  final String? image;
  final DateTime? timestamp;

  const Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.image,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [senderId, receiverId, text, image, timestamp];
}
