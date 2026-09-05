import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/utils/context_extension.dart';
import '../widgets/main_bottom_nav_bar.dart';

class HomeShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeShell({
    super.key,
    required this.navigationShell,
  });

  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isHome =
        navigationShell.currentIndex == 0;

    return Scaffold(
      backgroundColor: AppColors.white,

      body: navigationShell,

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,

      floatingActionButton: isHome
          ? Container(
        padding: const EdgeInsets.all(8),
        width: context.h(60),
        height: context.w(60),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.orangeSurface,
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
          onPressed: () {
            // TODO: Navigate to Create Post
          },
          child: const Icon(
            CupertinoIcons.add,
            color: AppColors.black,
          ),
        ),
      )
          : null,

      bottomNavigationBar: MainBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}