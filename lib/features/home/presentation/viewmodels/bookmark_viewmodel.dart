import 'package:flutter/material.dart';

enum BookmarkTab { bookmarks, paper, subject }

class BookmarkViewModel extends ChangeNotifier {
  BookmarkTab _selectedTab = BookmarkTab.bookmarks;

  BookmarkTab get selectedTab => _selectedTab;

  void changeTab(BookmarkTab tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  List<Map<String, String>> get contentList => [
        {
          'title': 'AIAPGET 2017',
          'logo': 'assets/aa.png',
        },
        {
          'title': 'Delhi MD 2009',
          'logo': 'assets/do.png',
        },
        {
          'title': 'Andhra pradesh 2013',
          'logo': 'assets/ma.png',
        },
        {
          'title': 'Jaipur MD 2001',
          'logo': 'assets/nasa.png',
        },
        {
          'title': 'Agra MD 2007',
          'logo': 'assets/sa.png',
        },
      ];
}
