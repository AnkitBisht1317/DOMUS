import 'package:flutter/material.dart';

// ... existing code ...

class HomeDrawerViewModel extends ChangeNotifier {
  // The navigatorKey is no longer needed here as navigation is handled in home_drawer.dart
  // final GlobalKey<NavigatorState>? navigatorKey;

  // HomeDrawerViewModel({this.navigatorKey});

  final List<DrawerItem> drawerItems = [
    // My Details section
    DrawerItem(
      title: 'Profile',
      icon: Icons.person_outline,
      onTap: () {},
      category: 'Main',
    ),
    DrawerItem(
      title: 'Bookmarks',
      icon: Icons.bookmark_outline,
      onTap: () {},
      category: 'Main',
    ),
    DrawerItem(
      title: 'Quick Fact',
      icon: Icons.lightbulb_outline,
      onTap: () {},
      category: 'Main',
    ),
    // Miscellaneous section
    DrawerItem(
      title: 'Testimonials',
      icon: Icons.chat_bubble_outline,
      onTap: () {},
      category: 'Miscellaneous',
    ),
    DrawerItem(
      title: 'Homoeopathic Events',
      icon: Icons.event_note,
      onTap: () {},
      category: 'Miscellaneous',
    ),
    DrawerItem(
      title: 'Homoeo Community',
      icon: Icons.people_outline,
      onTap: () {},
      category: 'Miscellaneous',
    ),
    DrawerItem(
      title: 'AIM Academy',
      icon: Icons.school_outlined,
      onTap: () {},
      category: 'Miscellaneous',
    ),
    DrawerItem(
      title: 'Notification',
      icon: Icons.notifications_none,
      onTap: () {}, // Keep empty since navigation is handled in home_drawer.dart
      category: 'Miscellaneous',
    ),
    // About Us section
    DrawerItem(
      title: 'Rate',
      icon: Icons.star_outline,
      onTap: () {},
      category: 'About Us',
    ),
    DrawerItem(
      title: 'Share',
      icon: Icons.share,
      onTap: () {},
      category: 'About Us',
    ),
    DrawerItem(
      title: 'Feedback',
      icon: Icons.feedback_outlined,
      onTap: () {},
      category: 'About Us',
    ),
    DrawerItem(
      title: 'AIM Team',
      icon: Icons.groups_outlined,
      onTap: () {},
      category: 'About Us',
    ),
    DrawerItem(
      title: 'About',
      icon: Icons.info_outline,
      onTap: () {},
      category: 'About Us',
    ),
    DrawerItem(
      title: 'Gmail',
      icon: Icons.info_outline,
      onTap: () {},
      category: 'Contact Us',
    ),
  ];

  Map<String, List<DrawerItem>> get groupedDrawerItems {
    return {
      'Main': drawerItems.where((item) => item.category == 'Main').toList(),
      'Miscellaneous': drawerItems.where((item) => item.category == 'Miscellaneous').toList(),
      'About Us': drawerItems.where((item) => item.category == 'About Us').toList(),
      'Contact Us': drawerItems.where((item) => item.category == 'Contact Us').toList(),
    };
  }
}

class DrawerItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final String category;

  DrawerItem({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.category,
  });
}