import 'package:flutter/material.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/features/profile/presentation/controllers/profile_form_controllers.dart';
import 'package:social_media_app/features/profile/presentation/pages/widgets/custom_dropdown.dart';
import 'package:social_media_app/features/profile/presentation/validators/profile_validators.dart';
import 'package:social_media_app/features/profile/presentation/widgets/custom_text_form_field.dart';

class ChasingSection extends StatelessWidget {
  const ChasingSection({
    super.key,
    required this.controllers,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  final ProfileFormControllers controllers;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDropdownField(
          label: 'Chasing Category',
          hintText: 'Chasing Category',
          entries: [
            DropdownMenuEntry(
              value: 'trends',
              label: 'Trend Chasing',
              style: MenuItemButton.styleFrom(
                textStyle: AppTextStyles.textField,
              ),
            ),
            DropdownMenuEntry(
              value: 'news',
              label: 'News Chasing',
              style: MenuItemButton.styleFrom(
                textStyle: AppTextStyles.textField,
              ),
            ),
          ],
          initialValue: selectedCategory,
          onSelected: onCategoryChanged,
          validator: ProfileValidators.chasingCategory,
        ),

        const SizedBox(height: 15),

        CustomTextFormField(
          label: 'Chasing Description',
          maxLines: 5,
          controller: controllers.chasingDescription,
          validator: ProfileValidators.chasingDescription,
        ),
      ],
    );
  }
}
