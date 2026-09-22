import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/core/constants/app_assets.dart';
import 'package:social_media_app/core/utils/context_extension.dart';
import 'package:social_media_app/core/widgets/app_snack_bar.dart';
import 'package:social_media_app/features/profile/presentation/bloc/profile/profile_cubit.dart';
import 'package:social_media_app/features/profile/presentation/bloc/profile/profile_state.dart';
import 'package:social_media_app/features/profile/presentation/controllers/profile_form_controllers.dart';
import 'package:social_media_app/features/profile/presentation/pages/widgets/custom_image_picker_box.dart';
import 'package:social_media_app/features/profile/presentation/widgets/address_section.dart';
import 'package:social_media_app/features/profile/presentation/widgets/chasing_section.dart';
import 'package:social_media_app/features/profile/presentation/widgets/custom_button.dart';
import 'package:social_media_app/features/profile/presentation/widgets/custom_description.dart';
import 'package:social_media_app/features/profile/presentation/widgets/document_upload_bottom_sheet.dart';
import 'package:social_media_app/features/profile/presentation/widgets/personal_info_section.dart';
import 'package:social_media_app/features/profile/presentation/widgets/skip_button.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final controllers = ProfileFormControllers();

  XFile? selectedProfileImage;

  String? selectedGender;
  String? selectedCountry;
  String? selectedState;
  String? selectedChasingCategory;

  @override
  void dispose() {
    controllers.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final profile = controllers.toProfile(
      gender: selectedGender,
      country: selectedCountry,
      state: selectedState,
      chasingCategory: selectedChasingCategory,
    );

    context.read<ProfileCubit>().save(
      profile,
      imagePath: selectedProfileImage?.path,
    );
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final month = pickedDate.month.toString().padLeft(2, '0');
      final day = pickedDate.day.toString().padLeft(2, '0');
      final year = pickedDate.year.toString();

      controllers.dateOfBirth.text = '$month/$day/$year';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete your Profile')),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSuccess) {
            AppSnackBar.showSuccess(context, 'Profile saved successfully.');
            //Go To Home
          }
          if (state is ProfileFailure) {
            AppSnackBar.showError(context, state.message);
          }
        },
        builder: (context, state) => Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 15),

                const CustomDescription(
                  text: 'Please fill the following information to complete your profile',
                ),

                const SizedBox(height: 20),

                CustomImagePickerBox(
                  title: 'Upload Picture',
                  assetIcon: Assets.imagesUploadPicture,
                  image: selectedProfileImage,
                  onTap: () async {
                    final image = await showModalBottomSheet<XFile>(
                      context: context,
                      builder: (context) => const DocumentUploadBottomSheet(),
                    );

                    if (image != null) {
                      setState(() {
                        selectedProfileImage = image;
                      });
                    }
                  },
                ),

                const SizedBox(height: 15),

                PersonalInfoSection(
                  controllers: controllers,
                  onGenderChanged: (String value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                  onSelectDate: _selectDate,
                ),

                const SizedBox(height: 15),

                AddressSection(
                  controllers: controllers,
                  selectedCountry: selectedCountry,
                  selectedState: selectedState,
                  onCountryChanged: (value) {
                    setState(() {
                      selectedCountry = value;
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      selectedState = value;
                    });
                  },
                ),

                const SizedBox(height: 15),

                ChasingSection(
                  controllers: controllers,
                  selectedCategory: selectedChasingCategory,
                  onCategoryChanged: (String? value) {
                    setState(() {
                      selectedChasingCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: context.w(335),
                  height: context.h(102),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: 'Save',
                          isLoading: state is ProfileLoading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _saveProfile();
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 5),

                      SkipButton(
                        onPressed: () {
                          //Go To Home
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
