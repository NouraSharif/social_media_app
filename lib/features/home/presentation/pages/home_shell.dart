import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/domain/usecases/get_posts_usecase.dart';
import 'package:social_media_app/core/domain/usecases/toggle_post_like_usecase.dart';
import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/core/utils/context_extension.dart';

import '../../../../core/injection_container.dart';
import '../bloc/post_feed_bloc.dart';
import '../bloc/post_feed_event.dart';
import '../widgets/main_bottom_nav_bar.dart';

class HomeShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeShell({super.key, required this.navigationShell});

  void _onTabSelected(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    // الـ Bloc هلق هون، بمستوى الـ Shell كامل - بيضل حي طول ما التطبيق
    // مفتوح على تاب الهوم، مش بس وقت فتح HomePage تحديداً
    return BlocProvider(
      create: (_) => PostFeedBloc(
        getPostsUseCase: sl<GetPostsUseCase>(),
        togglePostLikeUseCase: sl<TogglePostLikeUseCase>(),
      )..add(const PostFeedRequested()),
      child: _HomeShellView(
        navigationShell: navigationShell,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}

class _HomeShellView extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onTabSelected;

  const _HomeShellView({required this.navigationShell, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final bool isHome = navigationShell.currentIndex == 0;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: navigationShell,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isHome
          ? Container(
        padding: const EdgeInsets.all(8),
        width: context.h(60),
        height: context.w(60),
        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.orangeSurface),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
          onPressed: () async {
            // بننتظر لحد ما ترجع المستخدمة من شاشة إنشاء البوست
            await context.push(AppRoutes.createPost);
            // وبعدين بنطلب Refresh من نفس الـ Bloc - بما إنه هون
            // بمستوى الـ Shell، لسا موجود وما انقفل
            if (context.mounted) {
              context.read<PostFeedBloc>().add(const PostFeedRequested());
            }
          },
          child: const Icon(CupertinoIcons.add, color: AppColors.black),
        ),
      )
          : null,
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: onTabSelected,
      ),
    );
  }
}