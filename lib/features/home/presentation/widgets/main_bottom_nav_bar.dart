import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/utils/context_extension.dart';

class MainBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MainBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<IconData> _icons = [
    CupertinoIcons.house_fill,
    CupertinoIcons.person_3_fill,
    CupertinoIcons.chat_bubble_text_fill,
    CupertinoIcons.person_circle_fill,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.white,
      notchMargin: context.w(8),
      child: SizedBox(
        height: context.h(80),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _icons.length,
                (index) {
              if (index == 2) {
                return Row(
                  children: [
                    SizedBox(width: context.w(60)),
                    _NavIcon(
                      icon: _icons[index],
                      isSelected: currentIndex == index,
                      onTap: () => onTap(index),
                    ),
                  ],
                );
              }

              return _NavIcon(
                icon: _icons[index],
                isSelected: currentIndex == index,
                onTap: () => onTap(index),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        size: context.w(24),
        color: isSelected
            ? AppColors.black
            : AppColors.iconBackground,
      ),
    );
  }
}