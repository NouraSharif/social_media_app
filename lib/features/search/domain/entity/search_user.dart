class SearchUserEntity {
  final String otherUserId;
  final String displayName;
  final String username;
  final String? image;

  const SearchUserEntity({
    required this.otherUserId,
    required this.displayName,
    required this.username,
    this.image,
  });
}
