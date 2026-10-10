import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/constants/app_assets.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/new_message_user_item.dart';

class NewMessagePage extends StatefulWidget {
  const NewMessagePage({super.key});

  @override
  State<NewMessagePage> createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<NewMessageUserItem> users = [
      NewMessageUserItem(
        userImage: Assets.imagesPerson,
        displayName: 'Alaa Abu Jehad',
        username: '@jehad2026',
        onPressed: () {
          context.push(AppRoutes.chat);
        },
      ),
    ];
    return Container(
      height: context.h(738),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        spacing: 15,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'New Message',
                style: AppTextStyles.appBarTitle.copyWith(fontSize: 18),
              ),
              Container(
                height: 30,
                width: 30,
                color: AppColors.background,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          TextField(
            controller: searchController,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceLight,
              prefixIcon: const Icon(
                CupertinoIcons.search,
                color: Color(0xFF91999E),
              ),
              hintText: 'Search by username',
              hintStyle: AppTextStyles.body.copyWith(
                color: const Color(0xFF91999E),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, i) {
                return users[i];
              },
            ),
          ),
        ],
      ),
    );
  }
}
