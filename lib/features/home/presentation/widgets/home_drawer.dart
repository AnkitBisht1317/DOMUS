import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_drawer_viewmodel.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

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
                // Close button and Logo section
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
                // Bigger Logo
                Image.asset(
                  'assets/logo.png',
                  height: 100,
                ),
                const SizedBox(height: 40),
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // My Details section
                        const Text(
                          'My Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ..._buildAnimatedSection(drawerViewModel.groupedDrawerItems['Main'] ?? [], 0),
                        const SizedBox(height: 32),
                        // Miscellaneous section
                        const Text(
                          'Miscellaneous',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ..._buildAnimatedSection(drawerViewModel.groupedDrawerItems['Miscellaneous'] ?? [], 5),
                        const SizedBox(height: 32),
                        // About Us section
                        const Text(
                          'About Us',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ..._buildAnimatedSection(drawerViewModel.groupedDrawerItems['About Us'] ?? [], 10),
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

  List<Widget> _buildAnimatedSection(List<DrawerItem> items, int startIndex) {
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
        child: _buildDrawerItem(item),
      );
    }).toList();
  }

  Widget _buildDrawerItem(DrawerItem item) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        item.icon,
        color: Colors.white,
        size: 28,
      ),
      title: Text(
        item.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: item.onTap,
      minLeadingWidth: 24,
      visualDensity: VisualDensity.comfortable,
    );
  }
}