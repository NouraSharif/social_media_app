import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/core/theme/app_text_styles.dart';
import 'package:social_media_app/core/utils/context_extension.dart';
import 'package:social_media_app/core/widgets/app_snack_bar.dart';
import 'package:social_media_app/core/widgets/empty_state_message.dart';
import 'package:social_media_app/features/chat/presentation/bloc/new_message_user_cubit.dart';
import 'package:social_media_app/features/chat/presentation/bloc/new_message_user_state.dart';
import 'package:social_media_app/features/chat/presentation/pages/widgets/new_message_user_item.dart';

class NewMessagePage extends StatefulWidget {
  const NewMessagePage({super.key});

  @override
  State<NewMessagePage> createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  String? searchText;

  @override
  Widget build(BuildContext context) {
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
            onChanged: (val) {
              setState(() {
                searchText = val;
              });
              context.read<NewMessageUserCubit>().searchUsers(searchText!);
            },
          ),
          searchText != null
              ? Expanded(
                  child: BlocConsumer<NewMessageUserCubit, NewMessageUserState>(
                    listener: (context, state) {
                      if (state is NewMessageUserFailure) {
                        AppSnackBar.showError(context, state.message);
                      }
                    },
                    builder: (context, state) {
                      if (state is NewMessageUserLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is NewMessageSearchUsersLoaded) {
                        if (state.data.isEmpty) {
                          return const EmptyStateMessage(
                            message: 'No users found',
                          );
                        }
                        return ListView.builder(
                          itemCount: state.data.length,
                          itemBuilder: (context, i) {
                            final data = state.data[i];

                            return NewMessageUserItem(
                              userImage: data.image,
                              displayName: data.displayName,
                              username: data.userName,
                              onPressed: () {
                                context.push(
                                  AppRoutes.chat,
                                  extra: {
                                    'chatId': data.chatId,
                                    'otherUserId': data.otherUserId,
                                    'displayName': data.displayName,
                                    'userName': data.userName,
                                    'image': data.image,
                                  },
                                );
                              },
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                )
              : Expanded(
                  child: BlocConsumer<NewMessageUserCubit, NewMessageUserState>(
                    listener: (context, state) {
                      if (state is NewMessageUserFailure) {
                        AppSnackBar.showError(context, state.message);
                      }
                    },
                    builder: (context, state) {
                      if (state is NewMessageUserLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is NewMessageUserLoaded) {
                        if (state.data.isEmpty) {
                          return const EmptyStateMessage(
                            message: 'No users found',
                          );
                        }
                        return ListView.builder(
                          itemCount: state.data.length,
                          itemBuilder: (context, i) {
                            final data = state.data[i];

                            return NewMessageUserItem(
                              userImage: data.image,
                              displayName: data.displayName,
                              username: data.userName,
                              onPressed: () {
                                context.push(
                                  AppRoutes.chat,
                                  extra: {
                                    'chatId': data.chatId,
                                    'otherUserId': data.otherUserId,
                                    'displayName': data.displayName,
                                    'userName': data.userName,
                                    'image': data.image,
                                  },
                                );
                              },
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
