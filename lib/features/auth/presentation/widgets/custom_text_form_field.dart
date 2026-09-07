import 'package:flutter/material.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.label,
    this.hintText,
    this.maxLines,
    this.onTap,
    this.readOnly,
    this.suffixIcon,
    this.suffixStyle,
  });

  final String label;
  final String? hintText;
  final int? maxLines;
  final Function()? onTap;
  final bool? readOnly;
  final Widget? suffixIcon;
  final TextStyle? suffixStyle;
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
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.body,
            suffixIcon: suffixIcon,
          ),
          maxLines: maxLines,
          readOnly: readOnly ?? false,
          onTap: onTap,
        ),
      ],
    );
  }
}
