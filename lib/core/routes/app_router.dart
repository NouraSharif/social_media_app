import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/features/auth/presentation/pages/auth/auth_page.dart';
import 'package:social_media_app/features/auth/presentation/pages/check_email/check_email_page.dart';
import 'package:social_media_app/features/auth/presentation/pages/login/login_page.dart';
import 'package:social_media_app/features/auth/presentation/pages/new_password/new_password_page.dart';
import 'package:social_media_app/features/auth/presentation/pages/reset_password/reset_password_page.dart';
import 'package:social_media_app/features/auth/presentation/pages/signup/signup_page.dart';
import 'package:social_media_app/features/auth/presentation/pages/splash/splash_page.dart';
import 'package:social_media_app/features/auth/presentation/pages/verification/verification_page.dart';

//import 'package:social_media_app/core/routes/app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, builder) => const SplashPage(),
    ),
    GoRoute(path: AppRoutes.auth, builder: (context, builder) => AuthPage()),
    GoRoute(path: AppRoutes.login, builder: (context, builder) => LoginPage()),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, builder) => SignUpPage(),
    ),
    GoRoute(
      path: AppRoutes.resetpassword,
      builder: (context, builder) => ResetPasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.checkemail,
      builder: (context, builder) => CheckEmailPage(),
    ),
    GoRoute(
      path: AppRoutes.newpassword,
      builder: (context, builder) => NewPasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.verification,
      builder: (context, builder) => VerificationPage(),
    ),
  ],
);
