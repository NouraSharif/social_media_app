import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:social_media_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:social_media_app/features/auth/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  AuthRemoteDataSourceImpl(this.firebaseAuth);

  static const String supabaseFunctionsUrl =
      'https://lprernyrsvifiohgaenb.supabase.co/functions/v1';

  @override
  Future<UserModel> signup({
    required String email,
    required String password,
  }) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;

    return UserModel.fromFirebaseUser(id: user.uid, email: user.email!);
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;

    return UserModel.fromFirebaseUser(id: user.uid, email: user.email!);
  }

  @override
  Future<void> sendResetOtp({required String email}) async {
    final response = await http.post(
      Uri.parse('$supabaseFunctionsUrl/resend-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['error'] ?? 'Failed to send reset OTP');
    }
  }

  @override
  Future<String> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse('$supabaseFunctionsUrl/quick-service'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['error'] ?? 'Failed to verify OTP');
    }

    return data['resetToken'];
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$supabaseFunctionsUrl/dynamic-action'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'resetToken': resetToken,
        'newPassword': newPassword,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['error'] ?? 'Failed to reset password');
    }
  }
}
