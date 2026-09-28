import 'package:flutter/material.dart';
import 'package:social_media_app/features/profile/domain/entities/profile.dart';

class ProfileFormControllers {
  final username = TextEditingController();
  final displayName = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final bio = TextEditingController();
  final dateOfBirth = TextEditingController();
  final address = TextEditingController();
  final city = TextEditingController();
  final zipCode = TextEditingController();
  final chasingDescription = TextEditingController();

  Profile toProfile({
    required String? gender,
    required String? country,
    required String? state,
    required String? chasingCategory,
    String? profileImageUrl,
  }) {
    return Profile(
      username: username.text.trim(),
      displayName: displayName.text.trim(),
      firstName: firstName.text.trim(),
      lastName: lastName.text.trim(),
      bio: bio.text.trim(),
      dateOfBirth: dateOfBirth.text.trim(),
      gender: gender ?? '',
      address: address.text.trim(),
      country: country ?? '',
      state: state ?? '',
      city: city.text.trim(),
      zipCode: zipCode.text.trim(),
      chasingCategory: chasingCategory ?? '',
      chasingDescription: chasingDescription.text.trim(),
      profileImageUrl: profileImageUrl,
    );
  }

  void dispose() {
    username.dispose();
    displayName.dispose();
    firstName.dispose();
    lastName.dispose();
    bio.dispose();
    dateOfBirth.dispose();
    address.dispose();
    city.dispose();
    zipCode.dispose();
    chasingDescription.dispose();
  }
}
