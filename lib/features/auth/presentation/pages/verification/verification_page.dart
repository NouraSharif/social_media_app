import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/core/utils/context_extension.dart';
import 'package:social_media_app/features/auth/presentation/bloc/verification/verification_cubit.dart';
import 'package:social_media_app/features/auth/presentation/bloc/verification/verification_state.dart';
import 'package:social_media_app/features/auth/presentation/pages/verification/widgets/document_upload_card.dart';
import 'package:social_media_app/features/auth/presentation/pages/verification/widgets/verification_radio_tile.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_description.dart';
import 'package:social_media_app/features/auth/presentation/widgets/skip_button.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String selectedValue = 'id_card';

  File? idCardFront;
  File? idCardBack;

  File? driverLicenseFront;
  File? driverLicenseBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verification')),
      body: BlocConsumer<VerificationCubit, VerificationState>(
        listener: (context, state) {
          if (state is VerificationSuccess) {
            context.go(AppRoutes.completeProfile);
          }

          if (state is VerificationFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) => state is VerificationLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 25),
                child: Column(
                  children: [
                    const CustomDescription(
                      text: 'Please upload your documents',
                    ),

                    const SizedBox(height: 50),

                    Container(
                      width: double.infinity,
                      height: context.h(437),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.textPrimary.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      child: RadioGroup<String>(
                        groupValue: selectedValue,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedValue = value;
                            });
                          }
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              VerificationRadioTile(
                                label: 'Identification Card',
                                selectedValue: selectedValue,
                                value: 'id_card',
                              ),

                              if (selectedValue == 'id_card')
                                DocumentUploadCard(
                                  onFrontChanged: (file) {
                                    idCardFront = file;
                                  },
                                  onBackChanged: (file) {
                                    idCardBack = file;
                                  },
                                ),

                              VerificationRadioTile(
                                label: 'Driver License',
                                selectedValue: selectedValue,
                                value: 'driver_license',
                              ),

                              if (selectedValue == 'driver_license')
                                DocumentUploadCard(
                                  onFrontChanged: (file) {
                                    driverLicenseFront = file;
                                  },
                                  onBackChanged: (file) {
                                    driverLicenseBack = file;
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 68),

                    CustomButton(
                      text: 'Next',
                      onPressed: () {
                        final isIdCard = selectedValue == 'id_card';

                        final File? frontImage = isIdCard
                            ? idCardFront
                            : driverLicenseFront;

                        final File? backImage = isIdCard
                            ? idCardBack
                            : driverLicenseBack;

                        if (frontImage == null || backImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please upload both sides of the document',
                              ),
                            ),
                          );
                          return;
                        }

                        context.read<VerificationCubit>().uploadDocuments(
                          verificationType: selectedValue,
                          imageFront: frontImage,
                          imageBack: backImage,
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    SkipButton(
                      onPressed: () {
                        context.push(AppRoutes.completeProfile);
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
