import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/features/profile/presentation/bloc/profile/profile_cubit.dart';
import 'package:social_media_app/features/profile/presentation/pages/complete_profile_page.dart';

//import 'package:social_media_app/core/routes/app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.completeProfile,
  routes: [
    // GoRoute(
    //   path: AppRoutes.splash,
    //   builder: (context, builder) => const SplashView(),
    // ),
    GoRoute(
      path: AppRoutes.completeProfile,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => ProfileCubit(
            saveProfile: saveProfile,
            getProfile: getProfile,
            uploadProfileImage: uploadProfileImage,
          ),
          child: CompleteProfilePage(),
        );
      },
    ),
  ],
);
