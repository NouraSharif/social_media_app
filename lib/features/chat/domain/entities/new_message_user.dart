class NewMessageUserEntity {
  // Used to navigate to the existing chat when the user taps the item.
  // This field may be removed when the page switches to displaying
  // users based on follow/follower relationships.
  final String chatId;
  final String otherUserId;
  final String displayName;
  final String userName;
  final String? image;

  const NewMessageUserEntity({
    required this.chatId,
    required this.otherUserId,
    required this.displayName,
    required this.userName,
    required this.image,
  });
}
