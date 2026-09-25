import 'package:flutter/material.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.hintText,
    this.maxLines,
    this.onTap,
    this.readOnly,
    this.suffixIcon,
    this.suffixStyle,
    this.obscureText = false,
  });
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final int? maxLines;
  final Function()? onTap;
  final bool? readOnly;
  final Widget? suffixIcon;
  final TextStyle? suffixStyle;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.small),
        TextFormField(
          controller: controller,
          validator: validator,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.body,
            suffixIcon: suffixIcon,
          ),
          maxLines: obscureText ? 1 : maxLines,
          readOnly: readOnly ?? false,
          onTap: onTap,
          obscureText: obscureText,
        ),
      ],
    );
  }
}
