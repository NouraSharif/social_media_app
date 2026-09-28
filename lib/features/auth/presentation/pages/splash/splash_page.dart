import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/constants/app_assets.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 1200), () {
      if (mounted) {
        context.go(AppRoutes.auth);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Image.asset(Assets.imagesLogo, width: 285, height: 82),
      ),
    );
  }
}
