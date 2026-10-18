class ChatEntity {
  final String chatId;
  final String otherUserId;
  final String? image;
  final String displayName;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final String lastMessageSenderId;

  const ChatEntity({
    required this.chatId,
    required this.otherUserId,
    required this.image,
    required this.displayName,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.lastMessageSenderId,
  });
}
