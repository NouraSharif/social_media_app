import 'package:social_media_app/features/search/domain/entity/search_user.dart';

class SearchUserModel extends SearchUserEntity {
  SearchUserModel({
    required super.otherUserId,
    required super.displayName,
    required super.username,
    super.image,
  });

  factory SearchUserModel.fromJson(Map<String, dynamic> json) {
    return SearchUserModel(
      otherUserId: json['otherUserId'],
      displayName: json['displayName'],
      username: json['username'],
      image: json['image'],
    );
  }
}
