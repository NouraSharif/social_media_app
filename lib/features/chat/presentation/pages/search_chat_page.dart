import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/widgets/app_snack_bar.dart';
import 'package:social_media_app/core/widgets/empty_state_message.dart';
import 'package:social_media_app/features/search/presentation/bloc/search_users_cubit.dart';
import 'package:social_media_app/features/search/presentation/bloc/search_users_state.dart';
import 'package:social_media_app/features/search/presentation/widgets/search_user_item.dart';

class SearchChatPage extends StatefulWidget {
  const SearchChatPage({super.key});

  @override
  State<SearchChatPage> createState() => _SearchChatPageState();
}

class _SearchChatPageState extends State<SearchChatPage> {
  bool showSearchResults = true;
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(CupertinoIcons.search),
                  suffixIcon: ValueListenableBuilder(
                    valueListenable: searchController,
                    builder: (context, value, child) {
                      if (value.text.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return IconButton(
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            showSearchResults = false;
                          });
                        },
                        icon: const Icon(Icons.close, color: Color(0xFFB9BDC1)),
                      );
                    },
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    showSearchResults = val.trim().isNotEmpty;
                  });
                  context.read<SearchUsersCubit>().searchUsers(val);
                },
              ),
              const SizedBox(height: 17.0),
              showSearchResults
                  ? Expanded(
                      child: BlocConsumer<SearchUsersCubit, SearchUsersState>(
                        listener: (context, state) {
                          if (state is SearchUsersFailure) {
                            AppSnackBar.showError(context, state.message);
                          }
                        },
                        builder: (context, state) {
                          if (state is SearchUsersLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is SearchUsersLoaded) {
                            if (state.data.isEmpty) {
                              return const EmptyStateMessage(
                                message: 'No users found',
                              );
                            }
                            return ListView.builder(
                              itemCount: state.data.length,
                              itemBuilder: (context, i) {
                                final data = state.data[i];
                                return SearchUserItem(
                                  userImage: data.image,
                                  displayName: data.displayName,
                                  username: data.username,
                                  onTap: () {
                                    // Navigate to the user's profile
                                  },
                                );
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
