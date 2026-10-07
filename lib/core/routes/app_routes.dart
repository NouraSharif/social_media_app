class AppRoutes {
  AppRoutes._();

  // Authentication
  static const String splash = '/splash';

  static const home = '/home';
  static const community = '/community';
  static const chat = '/chat';
  static const profile = '/profile';
  static const createPost = '/create-post';
  static const postDetails = '/post-details/:postId';
  static String postDetailsPath(String postId) => '/post-details/$postId';
  static const String auth = '/auth';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String resetPassword = '/resetpassword';
  static const String checkEmail = '/checkemail';
  static const String newPassword = '/newpassword';
  static const String verification = '/verification';
  static const String completeProfile = '/completeprofile';
}
