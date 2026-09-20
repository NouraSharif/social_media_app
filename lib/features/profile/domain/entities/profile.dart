class Profile {
  final String username;
  final String displayName;
  final String firstName;
  final String lastName;
  final String bio;
  final String dateOfBirth;
  final String gender;
  final String address;
  final String country;
  final String state;
  final String city;
  final String zipCode;
  final String chasingCategory;
  final String chasingDescription;
  final String? profileImageUrl;

  const Profile({
    required this.username,
    required this.displayName,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.country,
    required this.state,
    required this.city,
    required this.zipCode,
    required this.chasingCategory,
    required this.chasingDescription,
    this.profileImageUrl,
  });
}
