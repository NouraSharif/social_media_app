import 'package:flutter_test/flutter_test.dart';
import 'package:social_media_app/features/profile/presentation/validators/profile_validators.dart';

void main() {
  group('ProfileValidators', () {
    group('username', () {
      test('returns error when username is empty', () {
        expect(ProfileValidators.username(''), 'Username is required.');
      });

      test('accepts a valid username', () {
        expect(ProfileValidators.username('noura_123'), isNull);
      });

      test('accepts username with a leading @', () {
        expect(ProfileValidators.username('@noura_123'), isNull);
      });

      test('rejects uppercase letters', () {
        expect(
          ProfileValidators.username('Noura'),
          'Use only lowercase letters, numbers, and underscores.',
        );
      });

      test('rejects spaces and special characters', () {
        expect(
          ProfileValidators.username('noura hassanin'),
          'Use only lowercase letters, numbers, and underscores.',
        );
      });
    });

    group('displayName', () {
      test('returns error when value is empty', () {
        expect(ProfileValidators.displayName('  '), 'Display name is required');
      });

      test('accepts a non-empty value', () {
        expect(ProfileValidators.displayName('Noura Hassanin'), isNull);
      });
    });

    group('bio', () {
      test('allows an empty bio', () {
        expect(ProfileValidators.bio(''), isNull);
      });

      test('accepts bio up to 150 characters', () {
        expect(ProfileValidators.bio('a' * 150), isNull);
      });

      test('rejects bio longer than 150 characters', () {
        expect(
          ProfileValidators.bio('a' * 151),
          'Bio must not exceed 150 characters',
        );
      });
    });

    group('dateOfBirth', () {
      test('returns error when date is empty', () {
        expect(ProfileValidators.dateOfBirth(''), 'Date of birth is required');
      });

      test('accepts a non-empty date', () {
        expect(ProfileValidators.dateOfBirth('2000-01-01'), isNull);
      });
    });

    group('chasingDescription', () {
      test('allows an empty description', () {
        expect(ProfileValidators.chasingDescription(''), isNull);
      });

      test('accepts description up to 500 characters', () {
        expect(ProfileValidators.chasingDescription('a' * 500), isNull);
      });

      test('rejects description longer than 500 characters', () {
        expect(
          ProfileValidators.chasingDescription('a' * 501),
          'Description must not exceed 500 characters',
        );
      });
    });
  });
}
