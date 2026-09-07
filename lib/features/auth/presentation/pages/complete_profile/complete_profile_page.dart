import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_assets.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';
import 'package:social_media_app/features/auth/presentation/pages/complete_profile/widgets/custom_dropdown.dart';
import 'package:social_media_app/features/auth/presentation/pages/complete_profile/widgets/custom_gender_picker.dart';
import 'package:social_media_app/features/auth/presentation/pages/complete_profile/widgets/custom_image_picker_box.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_description.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:social_media_app/features/auth/presentation/widgets/document_upload_bottom_sheet.dart';
import 'package:social_media_app/features/auth/presentation/widgets/skip_button.dart';

class CompleteProfilePage extends StatelessWidget {
  CompleteProfilePage({super.key});

  final GlobalKey<FormState> formstate = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete your Profile')),
      body: Form(
        key: formstate,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 15),
            const CustomDescription(
              text: 'Please fill the following information to complete your profile',
            ),
            const SizedBox(height: 20),
            CustomImagePickerBox(
              title: 'Upload Picture',
              assetIcon: Assets.imagesUploadPicture,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const DocumentUploadBottomSheet(),
                );
              },
            ),
            const SizedBox(height: 15),
            CustomTextFormField(label: "Username", hintText: "@a.b"),
            const SizedBox(height: 15),
            CustomTextFormField(label: "Display Name", hintText: 'Superman'),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: "First Name",
                    hintText: 'Jamaal',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextFormField(
                    label: "Last Name",
                    hintText: 'Williams',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            CustomTextFormField(label: "Bio", maxLines: 5),
            const SizedBox(height: 15),
            CustomTextFormField(
              label: "Date of Birth",
              hintText: 'MM/DD/YYYY',
              readOnly: true,
              suffixIcon: Icon(
                Icons.calendar_month_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2026),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {}
              },
            ),
            const SizedBox(height: 15),
            CustomGenderPicker(),
            const SizedBox(height: 15),
            CustomTextFormField(label: "Address", hintText: 'Enter Address'),
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
              onSelected: (value) {},
            ),
            const SizedBox(height: 15),
            CustomDropdownField(
              label: 'State',
              hintText: 'Select',
              entries: [
                DropdownMenuEntry(
                  value: 'single',
                  label: 'Single',
                  style: MenuItemButton.styleFrom(
                    textStyle: AppTextStyles.textField,
                  ),
                ),
                DropdownMenuEntry(
                  value: 'married',
                  label: 'Married',
                  style: MenuItemButton.styleFrom(
                    textStyle: AppTextStyles.textField,
                  ),
                ),
                DropdownMenuEntry(
                  value: 'engaged',
                  label: 'Engaged',
                  style: MenuItemButton.styleFrom(
                    textStyle: AppTextStyles.textField,
                  ),
                ),
              ],
              onSelected: (value) {},
            ),
            const SizedBox(height: 15),
            CustomTextFormField(label: "City"),
            const SizedBox(height: 15),
            CustomTextFormField(label: "ZIP Code"),
            const SizedBox(height: 15),
            CustomDropdownField(
              label: 'Chasing Category',
              hintText: 'Chasing Category',
              onSelected: (value) {},
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
            ),
            const SizedBox(height: 15),
            CustomTextFormField(label: "Chasing Description", maxLines: 5),
            const SizedBox(height: 30),
            SizedBox(
              width: context.w(335),
              height: context.h(102),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(text: 'Save', onPressed: () {}),
                  ),
                  const SizedBox(height: 5),
                  SkipButton(onPressed: () {}),
                ],
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
