import 'package:flutter/material.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.small),

        TextFormField(
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          // decoration: InputDecoration.collapsed(hintText: hintText),
        ),
      ],
    );
  }
}
