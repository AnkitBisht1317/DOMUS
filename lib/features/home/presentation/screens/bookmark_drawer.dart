import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/bookmark_viewmodel.dart';

class BookmarkDrawer extends StatelessWidget {
  const BookmarkDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookmarkViewModel(),
      child: const _BookmarkDrawerBody(),
    );
  }
}

class _BookmarkDrawerBody extends StatelessWidget {
  const _BookmarkDrawerBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BookmarkViewModel>(context);
    final tab = viewModel.selectedTab;

    return Scaffold(
      backgroundColor: const Color(0xFF022150),
      appBar: AppBar(
        backgroundColor: const Color(0xFF022150),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Bookmarks',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Top-right Filter Row
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Row(
                      children: [
                        const Spacer(),
                        Row(
                          children: const [
                            Icon(Icons.filter_alt, color: Color(0xFF204771)),
                            SizedBox(width: 6),
                            Text(
                              'Filter',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Tabs
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        _buildTab(
                            context, 'Bookmarks', BookmarkTab.bookmarks, tab),
                        const SizedBox(width: 10),
                        _buildTab(context, 'Paper', BookmarkTab.paper, tab),
                        const SizedBox(width: 10),
                        _buildTab(context, 'Subject', BookmarkTab.subject, tab),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // List Items
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(top: 10),
                      children: viewModel.contentList
                          .map((data) => _buildListItem(data))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, String label, BookmarkTab tabType,
      BookmarkTab current) {
    final isSelected = current == tabType;
    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<BookmarkViewModel>().changeTab(tabType),
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF204771) : Colors.white,
            border: Border.all(color: const Color(0xFF204771)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF204771),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(Map<String, String> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF204771),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minLeadingWidth: 0, // Prevent extra space
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SizedBox(
              height: 30, // Adjusted to match screenshot
              width: 30,
              child: Image.asset(
                data['logo']!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            data['title']!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.5, // Slightly smaller to match layout
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
