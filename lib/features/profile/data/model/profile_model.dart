import 'package:social_media_app/features/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  ProfileModel({
    required super.username,
    required super.displayName,
    required super.firstName,
    required super.lastName,
    required super.bio,
    required super.dateOfBirth,
    required super.gender,
    required super.address,
    required super.country,
    required super.state,
    required super.city,
    required super.zipCode,
    required super.chasingCategory,
    required super.chasingDescription,
    required super.profileImageUrl,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      username: map['username'] ?? '',
      displayName: map['displayName'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      bio: map['bio'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      gender: map['gender'] ?? '',
      address: map['address'] ?? '',
      country: map['country'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      zipCode: map['zipCode'] ?? '',
      chasingCategory: map['chasingCategory'] ?? '',
      chasingDescription: map['chasingDescription'] ?? '',
      profileImageUrl: map['profileImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'displayName': displayName,
      'firstName': firstName,
      'lastName': lastName,
      'bio': bio,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'address': address,
      'country': country,
      'state': state,
      'city': city,
      'zipCode': zipCode,
      'chasingCategory': chasingCategory,
      'chasingDescription': chasingDescription,
      'profileImageUrl': profileImageUrl,
    };
  }
}
