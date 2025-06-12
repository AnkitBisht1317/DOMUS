import 'package:domus/features/home/presentation/screens/about_drawer.dart';
import 'package:domus/features/home/presentation/screens/aim_academy_drawer.dart';
import 'package:domus/features/home/presentation/screens/aim_team_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';

import '../screens/bookmark_drawer.dart';
import '../screens/homoeo_community_drawer.dart';
import '../screens/notification_screen.dart';
import '../screens/profile_drawer.dart';
import '../screens/quickfact_drawer.dart';
import '../viewmodels/home_drawer_viewmodel.dart';

class HomeDrawer extends StatelessWidget {
  final AdvancedDrawerController controller;
  const HomeDrawer({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeDrawerViewModel>(
      builder: (context, drawerViewModel, child) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.hideDrawer();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Image.asset(
                  'assets/logo.png',
                  height: 100,
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('My Details'),
                        const SizedBox(height: 20),
                        ..._buildAnimatedSection(
                          context,
                          drawerViewModel.groupedDrawerItems['Main'] ?? [],
                          0,
                        ),
                        const SizedBox(height: 32),
                        _buildSectionTitle('Miscellaneous'),
                        const SizedBox(height: 20),
                        ..._buildAnimatedSection(
                          context,
                          drawerViewModel.groupedDrawerItems['Miscellaneous'] ??
                              [],
                          5,
                        ),
                        const SizedBox(height: 32),
                        _buildSectionTitle('About Us'),
                        const SizedBox(height: 20),
                        ..._buildAnimatedSection(
                          context,
                          drawerViewModel.groupedDrawerItems['About Us'] ?? [],
                          10,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  List<Widget> _buildAnimatedSection(
      BuildContext context, List<DrawerItem> items, int startIndex) {
    return items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: 0.0),
        duration: Duration(milliseconds: 200 + ((startIndex + index) * 100)),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(value * 50, 0),
            child: Opacity(
              opacity: 1 - value,
              child: child,
            ),
          );
        },
        child: _buildDrawerItem(item, context),
      );
    }).toList();
  }

  Widget _buildDrawerItem(DrawerItem item, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(item.icon, color: Colors.white, size: 28),
      title: Text(
        item.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: () {
        controller.hideDrawer();
        Future.delayed(const Duration(milliseconds: 300), () {
          if (item.title == 'Profile') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileDrawer()),
            );
          } else if (item.title == 'Notification') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationScreen()),
            );
          } else if (item.title == 'Bookmarks') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BookmarkDrawer()),
            );
          } else if (item.title == 'Quick Fact') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QuickFactScreen()),
            );
          } else if (item.title == 'Homoeo Community') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomoeoCommunityDrawer()),
            );
          } else if (item.title == 'About') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutDrawer()),
            );
          } else if (item.title == 'AIM Academy') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AimAcademyDrawer()),
            );
          } else if (item.title == 'AIM Team') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AimTeamDrawer()),
            );
          } else {
            item.onTap?.call();
          }
        });
      },
      minLeadingWidth: 24,
      visualDensity: VisualDensity.comfortable,
    );
  }
}
