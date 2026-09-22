import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/utils/context_extension.dart';

class AppSnackBar {
  AppSnackBar._();

  static void showError(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.error_outline_rounded,
      backgroundColor: AppColors.error,
    );
  }

  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle_outline_rounded,
      backgroundColor: AppColors.focus,
    );
  }

  static void showWarning(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.warning_amber_rounded,
      backgroundColor: AppColors.primary,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.info_outline_rounded,
      backgroundColor: AppColors.iconColor,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
  }) {
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.symmetric(
            horizontal: context.w(20),
            vertical: context.h(20),
          ),
          padding: EdgeInsets.zero,
          duration: const Duration(seconds: 3),
          content: Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(16),
              vertical: context.h(14),
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(context.w(14)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.15),
                  blurRadius: context.w(12),
                  offset: Offset(0, context.h(5)),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.white, size: context.w(24)),
                SizedBox(width: context.w(12)),
                Expanded(
                  child: Text(
                    message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: context.w(14),
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(width: context.w(8)),
                GestureDetector(
                  onTap: messenger.hideCurrentSnackBar,
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.white,
                    size: context.w(20),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
