import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../utils/context_extension.dart';

class StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const StatChip({required this.icon, required this.label, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: context.w(18), color: color),
        SizedBox(width: context.w(6)),
        Text(label, style: AppTextStyles.number.copyWith(color: color, fontSize: context.sp(12))),
      ],
    );
    return onTap == null ? content : GestureDetector(onTap: onTap, child: content);
  }
}