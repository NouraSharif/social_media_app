import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String hintText;
  final List<DropdownMenuEntry<String>> entries;
  final ValueChanged<String?> onSelected;
  final String? initialValue;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    required this.entries,
    required this.onSelected,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.small),
        SizedBox(height: context.h(4)),
        DropdownMenu<String>(
          width: double.infinity,
          hintText: hintText,
          textStyle: AppTextStyles.textField,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.white,
            hintStyle: AppTextStyles.body,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          trailingIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          onSelected: onSelected,
          dropdownMenuEntries: entries,
        ),
      ],
    );
  }
}
