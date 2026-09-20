import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';

class CustomGenderPicker extends StatefulWidget {
  const CustomGenderPicker({super.key});

  @override
  State<CustomGenderPicker> createState() => _CustomGenderPickerState();
}

class _CustomGenderPickerState extends State<CustomGenderPicker> {
  String selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Gender", style: AppTextStyles.small),
        SizedBox(height: context.h(11)),
        RadioGroup<String>(
          onChanged: (value) {
            setState(() {
              selectedGender = value!;
            });
          },
          groupValue: selectedGender,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<String>(
                value: 'Male',
                fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return null;
                  }
                  return AppColors.textSecondary;
                }),
              ),
              const Text('Male', style: AppTextStyles.textField),
              const SizedBox(width: 20),
              Radio<String>(
                value: 'Female',
                fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return null;
                  }
                  return AppColors.textSecondary;
                }),
              ),
              const Text('Female', style: AppTextStyles.textField),
            ],
          ),
        ),
      ],
    );
  }
}
