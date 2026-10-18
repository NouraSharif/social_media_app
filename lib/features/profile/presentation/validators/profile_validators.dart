class ProfileValidators {
  static String? _requiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required.';
    }

    final username = value.trim();
    final normalized = username.startsWith('@')
        ? username.substring(1)
        : username;

    if (!RegExp(r'^[a-z0-9_]+$').hasMatch(normalized)) {
      return 'Use only lowercase letters, numbers, and underscores.';
    }

    if (normalized.isEmpty) {
      return 'Username cannot be empty.';
    }

    return null;
  }

  static String? displayName(String? value) {
    return _requiredField(value, 'Display name');
  }

  static String? firstName(String? value) {
    return _requiredField(value, 'First name');
  }

  static String? lastName(String? value) {
    return _requiredField(value, 'Last name');
  }

  static String? bio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (value.trim().length > 150) {
      return 'Bio must not exceed 150 characters';
    }

    return null;
  }

  static String? dateOfBirth(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date of birth is required';
    }

    return null;
  }

  static String? gender(String? value) {
    return _requiredField(value, 'Gender');
  }

  static String? address(String? value) {
    return _requiredField(value, 'Address');
  }

  static String? country(String? value) {
    return _requiredField(value, 'Country');
  }

  static String? state(String? value) {
    return _requiredField(value, 'State');
  }

  static String? city(String? value) {
    return _requiredField(value, 'City');
  }

  static String? zipCode(String? value) {
    return _requiredField(value, 'Zip code');
  }

  static String? chasingCategory(String? value) {
    return _requiredField(value, 'Chasing category');
  }

  static String? chasingDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (value.trim().length > 500) {
      return 'Description must not exceed 500 characters';
    }

    return null;
  }
}
