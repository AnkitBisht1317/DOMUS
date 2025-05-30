import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/category_tabs_view_model.dart';
import '../../domain/models/category_tab.dart';
import '../../domain/models/category_icon.dart';

class CategoryTabs extends StatelessWidget {
  const CategoryTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryTabsViewModel>(
      builder: (context, viewModel, _) {
        return Column(
          children: [
            _buildTabs(viewModel),
            _buildIconGrid(viewModel),
          ],
        );
      },
    );
  }

  Widget _buildTabs(CategoryTabsViewModel viewModel) {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: viewModel.tabs.length,
        itemBuilder: (context, index) {
          final tab = viewModel.tabs[index];
          return _TabItem(
            tab: tab,
            onTap: () => viewModel.selectTab(index),
          );
        },
      ),
    );
  }

  Widget _buildIconGrid(CategoryTabsViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        children: [
          // First row of icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: viewModel.icons.take(5).map((icon) => _buildIconItem(icon)).toList(),
          ),
          const SizedBox(height: 16),
          // Second row of icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: viewModel.icons.skip(5).take(5).map((icon) => _buildIconItem(icon)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIconItem(CategoryIcon icon) {
    return Column(
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: const Color(0xFF1B3A63),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: icon.onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  icon.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 65,
          child: Text(
            icon.title,
            style: TextStyle(
              fontSize: icon.fontSize,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final CategoryTab tab;
  final VoidCallback onTap;

  const _TabItem({
    required this.tab,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            constraints: const BoxConstraints(
              minWidth: 80,
              minHeight: 32,
            ),
            decoration: BoxDecoration(
              color: tab.isSelected ? const Color(0xFFE7F0FF) : Colors.white,
              border: Border.all(
                color: const Color(0xFF001F54),
                width: 0.8,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                tab.title,
                style: TextStyle(
                  color: const Color(0xFF001F54),
                  fontSize: 13,
                  fontWeight: tab.isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
} 