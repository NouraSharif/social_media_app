import 'package:flutter/material.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/features/profile/presentation/controllers/profile_form_controllers.dart';
import 'package:social_media_app/features/profile/presentation/pages/widgets/custom_dropdown.dart';
import 'package:social_media_app/features/profile/presentation/validators/profile_validators.dart';
import 'package:social_media_app/features/profile/presentation/widgets/custom_text_form_field.dart';

class AddressSection extends StatelessWidget {
  const AddressSection({
    super.key,
    required this.controllers,
    required this.selectedCountry,
    required this.selectedState,
    required this.onCountryChanged,
    required this.onStateChanged,
  });

  final ProfileFormControllers controllers;

  final String? selectedCountry;
  final String? selectedState;

  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String?> onStateChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          label: 'Address',
          hintText: 'Enter Address',
          controller: controllers.address,
          validator: ProfileValidators.address,
        ),

        const SizedBox(height: 15),

        CustomDropdownField(
          label: 'Country',
          hintText: 'Select',
          entries: [
            DropdownMenuEntry(
              value: 'palestine',
              label: 'Palestine',
              style: MenuItemButton.styleFrom(
                textStyle: AppTextStyles.textField,
              ),
            ),
            DropdownMenuEntry(
              value: 'egypt',
              label: 'Egypt',
              style: MenuItemButton.styleFrom(
                textStyle: AppTextStyles.textField,
              ),
            ),
          ],
          initialValue: selectedCountry,
          onSelected: onCountryChanged,
          validator: ProfileValidators.country,
        ),

        const SizedBox(height: 15),

        CustomDropdownField(
          label: 'State',
          hintText: 'Select',
          entries: [
            DropdownMenuEntry(
              value: 'west_bank',
              label: 'West Bank',
              style: MenuItemButton.styleFrom(
                textStyle: AppTextStyles.textField,
              ),
            ),
            DropdownMenuEntry(
              value: 'gaza_strip',
              label: 'Gaza Strip',
              style: MenuItemButton.styleFrom(
                textStyle: AppTextStyles.textField,
              ),
            ),
          ],
          initialValue: selectedState,
          onSelected: onStateChanged,
          validator: ProfileValidators.state,
        ),

        const SizedBox(height: 15),

        CustomTextFormField(
          label: 'City',
          controller: controllers.city,
          validator: ProfileValidators.city,
        ),

        const SizedBox(height: 15),

        CustomTextFormField(
          label: 'ZIP Code',
          controller: controllers.zipCode,
          validator: ProfileValidators.zipCode,
        ),
      ],
    );
  }
}
