import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String hintText;
  final List<DropdownMenuEntry<String>> entries;
  final ValueChanged<String?> onSelected;
  final String? initialValue;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    required this.entries,
    required this.onSelected,
    this.initialValue,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: validator,
      builder: (FormFieldState<dynamic> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.small),
            const SizedBox(height: 4),
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
              trailingIcon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
              onSelected: (value) {
                field.didChange(value);
                onSelected(value);
              },
              dropdownMenuEntries: entries,
            ),
            // إظهار رسالة الـ validation
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 5),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
