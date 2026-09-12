class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';

  static const home = '/home';
  static const community = '/community';
  static const chat = '/chat';
  static const profile = '/profile';
  static const createPost = '/create-post';
  static const postDetails = '/post-details/:postId';
  static String postDetailsPath(String postId) => '/post-details/$postId';
}
