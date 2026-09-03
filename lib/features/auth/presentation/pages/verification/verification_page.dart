import 'package:flutter/material.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verification')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          children: [
            const Text(
              'Please upload your documents',
              style: AppTextStyles.body,
            ),
            Container(
              height: 400,
              width: 400,
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                //  border: Border.all(color: Colors.grey, width: 1),
              ),
              child: const Center(
                child: Text('Upload Area', style: AppTextStyles.body),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
