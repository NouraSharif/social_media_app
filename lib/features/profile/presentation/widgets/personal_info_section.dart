import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/features/profile/presentation/controllers/profile_form_controllers.dart';
import 'package:social_media_app/features/profile/presentation/pages/widgets/custom_gender_picker.dart';
import 'package:social_media_app/features/profile/presentation/validators/profile_validators.dart';
import 'package:social_media_app/features/profile/presentation/widgets/custom_text_form_field.dart';

class PersonalInfoSection extends StatelessWidget {
  const PersonalInfoSection({
    super.key,
    required this.controllers,
    required this.onGenderChanged,
    required this.onSelectDate,
  });

  final ProfileFormControllers controllers;
  final ValueChanged<String> onGenderChanged;
  final VoidCallback onSelectDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          label: 'Username',
          hintText: '@a.b',
          controller: controllers.username,
          validator: ProfileValidators.username,
        ),

        const SizedBox(height: 15),

        CustomTextFormField(
          label: 'Display Name',
          hintText: 'Superman',
          controller: controllers.displayName,
          validator: ProfileValidators.displayName,
        ),

        const SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                label: 'First Name',
                hintText: 'Jamaal',
                controller: controllers.firstName,
                validator: ProfileValidators.firstName,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomTextFormField(
                label: 'Last Name',
                hintText: 'Williams',
                controller: controllers.lastName,
                validator: ProfileValidators.lastName,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        CustomTextFormField(
          label: 'Bio',
          maxLines: 5,
          controller: controllers.bio,
          validator: ProfileValidators.bio,
        ),

        const SizedBox(height: 15),

        CustomTextFormField(
          label: 'Date of Birth',
          hintText: 'MM/DD/YYYY',
          controller: controllers.dateOfBirth,
          readOnly: true,
          suffixIcon: Icon(
            Icons.calendar_month_rounded,
            color: AppColors.textSecondary,
            size: 20,
          ),
          onTap: onSelectDate,
          validator: ProfileValidators.dateOfBirth,
        ),

        const SizedBox(height: 15),

        CustomGenderPicker(
          onChanged: onGenderChanged,
          validator: ProfileValidators.gender,
        ),
      ],
    );
  }
}
