import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/context_extension.dart';

class UAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // title parameter is required for AppBar
  final String title;

  @override
  Widget build(BuildContext context) {
    final buttonSize = context.w(48).clamp(40.0, 48.0);
    final iconSize = context.sp(24).clamp(20.0, 24.0);
    final badgeSize = context.w(8).clamp(6.0, 8.0);
    final decoration = BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(context.w(10).clamp(8.0, 10.0)),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Keep the toolbar content together on desktop without enlarging it.
        final inset =
            (constraints.maxWidth - 720).clamp(0.0, double.infinity) / 2;
        return AppBar(
          titleSpacing: context.w(16).clamp(12.0, 16.0),
          title: Padding(
            padding: EdgeInsetsDirectional.only(start: inset),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.appBarTitle.copyWith(
                fontSize: context.sp(24).clamp(20.0, 24.0),
              ),
            ),
          ),
          actions: [
            Container(
              width: buttonSize,
              height: buttonSize,
              decoration: decoration,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    iconSize: iconSize,
                    icon: const Icon(
                      CupertinoIcons.bell_solid,
                      color: AppColors.iconBackground,
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.25, -0.5),
                    child: IgnorePointer(
                      child: Container(
                        width: badgeSize,
                        height: badgeSize,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: context.w(12).clamp(8.0, 12.0)),
            Container(
              width: buttonSize,
              height: buttonSize,
              decoration: decoration,
              child: IconButton(
                onPressed: () {},
                iconSize: iconSize,
                icon: const Icon(
                  CupertinoIcons.search,
                  color: AppColors.secondaryIconColor,
                ),
              ),
            ),
            SizedBox(width: inset + context.w(14).clamp(10.0, 14.0)),
          ],
        );
      },
    );
  }
}
