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

  Profile copyWith({
    String? username,
    String? displayName,
    String? firstName,
    String? lastName,
    String? bio,
    String? dateOfBirth,
    String? gender,
    String? address,
    String? country,
    String? state,
    String? city,
    String? zipCode,
    String? chasingCategory,
    String? chasingDescription,
    String? profileImageUrl,
  }) {
    return Profile(
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      bio: bio ?? this.bio,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      chasingCategory: chasingCategory ?? this.chasingCategory,
      chasingDescription: chasingDescription ?? this.chasingDescription,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
