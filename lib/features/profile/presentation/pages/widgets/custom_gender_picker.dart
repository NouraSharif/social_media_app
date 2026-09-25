import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';

class CustomGenderPicker extends StatefulWidget {
  const CustomGenderPicker({
    super.key,
    required this.onChanged,
    required this.validator,
  });

  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;

  @override
  State<CustomGenderPicker> createState() => _CustomGenderPickerState();
}

class _CustomGenderPickerState extends State<CustomGenderPicker> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: widget.validator,
      builder: (FormFieldState<dynamic> field) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Gender", style: AppTextStyles.small),
              SizedBox(height: context.h(11)),
              RadioGroup<String>(
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedGender = value;
                  });
                  field.didChange(value);
                  widget.onChanged(value);
                },
                groupValue: selectedGender,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: 'Male',
                      fillColor: WidgetStateProperty.resolveWith<Color?>((
                        states,
                      ) {
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
                      fillColor: WidgetStateProperty.resolveWith<Color?>((
                        states,
                      ) {
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
          ),
        );
      },
    );
  }
}
