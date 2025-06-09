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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF022150),
      appBar: AppBar(
        backgroundColor: const Color(0xFF022150),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.white, size: screenWidth * 0.06),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Bookmarks',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.01),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Filter Row
                        Padding(
                          padding: EdgeInsets.fromLTRB(screenWidth * 0.03,
                              screenHeight * 0.015, screenWidth * 0.03, 0),
                          child: Row(
                            children: [
                              const Spacer(),
                              Row(
                                children: [
                                  Icon(Icons.filter_alt,
                                      color: const Color(0xFF204771),
                                      size: screenWidth * 0.05),
                                  SizedBox(width: screenWidth * 0.015),
                                  Text(
                                    'Filter',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.04,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.015),

                        // Tabs
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03),
                          child: Row(
                            children: [
                              _buildTab(context, 'Bookmarks',
                                  BookmarkTab.bookmarks, tab, screenWidth),
                              SizedBox(width: screenWidth * 0.025),
                              _buildTab(context, 'Paper', BookmarkTab.paper,
                                  tab, screenWidth),
                              SizedBox(width: screenWidth * 0.025),
                              _buildTab(context, 'Subject', BookmarkTab.subject,
                                  tab, screenWidth),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.015),
                      ],
                    ),
                  ),

                  // Bookmark List
                  viewModel.contentList.isEmpty
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.15),
                              child: Text(
                                'No Bookmarks',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _buildListItem(
                                viewModel.contentList[index], screenWidth),
                            childCount: viewModel.contentList.length,
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
      BookmarkTab current, double screenWidth) {
    final isSelected = current == tabType;
    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<BookmarkViewModel>().changeTab(tabType),
        child: Container(
          height: screenWidth * 0.09,
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
                fontSize: screenWidth * 0.035,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(Map<String, String> data, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03, vertical: screenWidth * 0.015),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF204771),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03, vertical: screenWidth * 0.015),
          minLeadingWidth: 0,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SizedBox(
              height: screenWidth * 0.08,
              width: screenWidth * 0.08,
              child: Image.asset(
                data['logo']!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            data['title']!,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
