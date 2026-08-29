import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/routes/app_routes.dart';

//import 'package:social_media_app/core/routes/app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    // GoRoute(
    //   path: AppRoutes.splash,
    //   builder: (context, builder) => const SplashView(),
    // ),
  ],
);
