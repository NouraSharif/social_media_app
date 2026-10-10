import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/constants/app_assets.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/core/utils/context_extension.dart';
import 'package:social_media_app/features/chat/presentation/pages/new_message_page.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/app_icon_button.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/chat_list_item.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/tab_button.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<ChatListItem> chats = [
      ChatListItem(
        userImage: Assets.imagesPerson,
        messageId: 0,
        displayName: 'Noura Hassanin',
        messageText: 'how Are You ,miss you',
        isActive: true,
        messageTime: '15 min',
        onDelete: () {
          // dispatch delete event
        },
        onTap: () {
          context.push(AppRoutes.chat);
        },
        unreadCount: 2,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          AppIconButton(
            icon: CupertinoIcons.bell_solid,
            showBadge: true,
            onPressed: () {},
          ),
          const SizedBox(width: 10),
          AppIconButton(
            icon: CupertinoIcons.search,
            onPressed: () => context.push(AppRoutes.searchChat),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                spacing: 6,
                children: [
                  Expanded(
                    child: TabButton(
                      label: 'Inbox',
                      isSelected: _tabController.index == 0,
                      onPressed: () => _tabController.animateTo(0),
                    ),
                  ),
                  Expanded(
                    child: TabButton(
                      label: 'Requests',
                      isSelected: _tabController.index == 1,
                      onPressed: () => _tabController.animateTo(1),
                    ),
                  ),
                  Container(
                    width: context.w(50),
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => const NewMessagePage(),
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Inbox
                  ListView.separated(
                    padding: const EdgeInsets.only(top: 10),
                    separatorBuilder: (context, i) =>
                        const SizedBox(height: 15),
                    itemCount: chats.length,
                    itemBuilder: (context, i) => chats[i],
                  ),
                  // Requests
                  const Center(child: Text('No requests')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
