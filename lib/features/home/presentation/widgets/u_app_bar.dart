
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class UAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // title parameter is required for AppBar
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.appBarTitle,
      ),
      actions: [
        Stack(
          children: [
            Container(
              decoration:BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ) ,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.bell_solid,
                  color: AppColors.iconBackground,
                ),
              ),
            ),
            Positioned(
              right: 15,
              top: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 12, right: 10),
          decoration:BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ) ,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.search,
              color: AppColors.iconBackground,
            ),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}