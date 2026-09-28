import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';

class VerificationRadioTile extends StatelessWidget {
  const VerificationRadioTile({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.value,
  });

  final String label;
  final String selectedValue;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: RadioListTile<String>(
        contentPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(vertical: -2),
        fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return null;
          }
          return AppColors.textSecondary;
        }),
        title: Text(
          label,
          style: selectedValue == value
              ? AppTextStyles.button.copyWith(fontSize: 14)
              : AppTextStyles.body,
        ),
        value: value,
      ),
    );
  }
}
