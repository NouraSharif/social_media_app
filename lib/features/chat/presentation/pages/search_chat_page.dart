import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchChatPage extends StatefulWidget {
  const SearchChatPage({super.key});

  @override
  State<SearchChatPage> createState() => _SearchChatPageState();
}

class _SearchChatPageState extends State<SearchChatPage> {
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
          child: TextField(
            controller: searchController,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
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
                    onPressed: searchController.clear,
                    icon: const Icon(Icons.close, color: Color(0xFFB9BDC1)),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
