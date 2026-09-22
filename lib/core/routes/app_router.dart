import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:social_media_app/features/auth/presentation/bloc/verification/verification_cubit.dart';
import 'package:social_media_app/features/auth/presentation/pages/auth/auth_page.dart';
import 'package:social_media_app/features/auth/presentation/pages/check_email/check_email_page.dart';
import 'package:social_media_app/features/auth/presentation/pages/login/login_page.dart';
import 'package:social_media_app/features/auth/presentation/pages/new_password/new_password_page.dart';
import 'package:social_media_app/features/auth/presentation/pages/reset_password/reset_password_page.dart';
import 'package:social_media_app/features/auth/presentation/pages/signup/signup_page.dart';
import 'package:social_media_app/features/auth/presentation/pages/splash/splash_page.dart';
import 'package:social_media_app/features/auth/presentation/pages/verification/verification_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.auth,
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
      path: AppRoutes.resetPassword,
      builder: (context, builder) => BlocProvider(
        create: (context) => AuthBloc(
          signupUseCase,
          loginUseCase,
          sendResetOtpUseCase,
          verifyResetUseCase,
          resetPasswordUseCase,
        ),
        child: ResetPasswordPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.checkEmail,
      builder: (context, builder) => BlocProvider(
        create: (context) => AuthBloc(
          signupUseCase,
          loginUseCase,
          sendResetOtpUseCase,
          verifyResetUseCase,
          resetPasswordUseCase,
        ),
        child: CheckEmailPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.newPassword,
      builder: (context, builder) => BlocProvider(
        create: (context) => AuthBloc(
          signupUseCase,
          loginUseCase,
          sendResetOtpUseCase,
          verifyResetUseCase,
          resetPasswordUseCase,
        ),
        child: NewPasswordPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.verification,
      builder: (context, builder) {
        return BlocProvider(
          create: (context) => VerificationCubit(verificationUseCase),
          child: VerificationPage(),
        );
      },
    ),
  ],
);
