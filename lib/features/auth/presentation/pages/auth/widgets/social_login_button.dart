import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/core/constants/app_colors.dart';

class SocialLoginButton extends StatelessWidget {
  const new({super.key, required this.icon, required this.backgroundColor});

  final FaIconData? icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.white,
        backgroundColor: backgroundColor,
        minimumSize: const Size(100, 50),
        padding: EdgeInsets.zero,
      ),
      child: FaIcon(icon, size: 29),
    );
  }
}
