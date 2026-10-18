import 'package:flutter/cupertino.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';

class EmptyStateMessage extends StatelessWidget {
  const EmptyStateMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message, style: AppTextStyles.body));
  }
}
