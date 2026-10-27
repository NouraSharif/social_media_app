import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/core/utils/context_extension.dart';
import 'package:social_media_app/core/widgets/app_snack_bar.dart';
import 'package:social_media_app/features/chat/data/model/chat_model.dart';
import 'package:social_media_app/features/chat/presentation/bloc/chats/chats_cubit.dart';
import 'package:social_media_app/features/chat/presentation/bloc/chats/chats_state.dart';
import 'package:social_media_app/features/chat/presentation/bloc/new_message_user_cubit.dart';
import 'package:social_media_app/features/chat/presentation/pages/new_message_page.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/app_icon_button.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/chat_list_item.dart';
import 'package:social_media_app/core/widgets/empty_state_message.dart';
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

    context.read<ChatsCubit>().getChats();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          builder: (context) => BlocProvider(
                            create: (_) => NewMessageUserCubit(
                              newMessageUserUseCase: newMessageUserUseCase,
                              newMessageSearchUsersUsecase:
                                  newMessageSearchUsersUsecase,
                            )..getMessageUsers(),
                            child: NewMessagePage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocConsumer<ChatsCubit, ChatsState>(
                listener: (context, state) {
                  if (state is ChatsFailure) {
                    AppSnackBar.showError(context, state.message);
                  }
                },

                builder: (BuildContext context, state) => TabBarView(
                  controller: _tabController,
                  children: [
                    // Inbox
                    state is ChatsLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state is ChatsLoaded
                        ? state.chats.isEmpty
                              ? const EmptyStateMessage(
                                  message: 'You have no conversations yet',
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.only(top: 10),
                                  separatorBuilder: (context, i) =>
                                      const SizedBox(height: 15),
                                  itemCount: state.chats.length,
                                  itemBuilder: (context, i) {
                                    final chat = state.chats[i];
                                    return ChatListItem(
                                      chatModel: ChatModel(
                                        chatId: chat.chatId,
                                        otherUserId: chat.otherUserId,
                                        image: chat.image,
                                        displayName: chat.displayName,
                                        userName: chat.userName,
                                        lastMessage: chat.lastMessage,
                                        lastMessageAt: chat.lastMessageAt,
                                        lastMessageSenderId:
                                            chat.lastMessageSenderId,
                                      ),
                                      isActive: true,
                                      unreadCount: 0,
                                      onDelete: () {
                                        context.read<ChatsCubit>().deleteChat(
                                          chat.chatId,
                                        );
                                      },
                                      onTap: () {
                                        context.push(
                                          AppRoutes.chat,
                                          extra: {
                                            'chatId': chat.chatId,
                                            'otherUserId': chat.otherUserId,
                                            'displayName': chat.displayName,
                                            'userName': chat.userName,
                                            'image': chat.image,
                                          },
                                        );
                                      },
                                    );
                                  },
                                )
                        : const SizedBox.expand(),
                    // Requests
                    const EmptyStateMessage(message: 'No requests'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
