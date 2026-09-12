import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/features/create_post/presentation/pages/create_post_page.dart';
import 'package:social_media_app/features/home/presentation/pages/home_page.dart';
import 'package:social_media_app/features/post_details/presentation/pages/post_details.dart';

import '../../features/home/presentation/pages/home_shell.dart';

//import 'package:social_media_app/core/routes/app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
   GoRoute(path: AppRoutes.postDetails,
     builder: (context , state){
     final postId = state.pathParameters['postId'];
     return PostDetailsPage(postId: postId!,);
     }
     ),
     GoRoute(
         path: AppRoutes.createPost,
     builder: (context , state){
       return  CreatePostPage();
     },),
    // home shell navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeShell(
          navigationShell: navigationShell,
        );
      },

      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) {
                return const HomePage();
              },
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.community,
              builder: (context, state) {
                return   Container();
              },
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.chat,
              builder: (context, state) {
                return  Container();
              },
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) {
                return  Container();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
