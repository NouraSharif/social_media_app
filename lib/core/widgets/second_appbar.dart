import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/context_extension.dart';

class SecondAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SecondAppbar({
    super.key, required this.title,
  });
  final String title;
  @override
  Size get preferredSize =>const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(CupertinoIcons.arrow_left, color: AppColors.textPrimary),
        onPressed: () => context.pop(),
      ),
      title: Text(
        title,
        style: AppTextStyles.appBarTitle.copyWith(fontSize: context.sp(20)),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.border, height: 1),
      ),
    );
  }


}