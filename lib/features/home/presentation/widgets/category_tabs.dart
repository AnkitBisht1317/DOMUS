import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/category_tabs_view_model.dart';
import '../../domain/models/category_tab.dart';
import '../../domain/models/category_icon.dart';

class CategoryTabs extends StatelessWidget {
  const CategoryTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(2, 0, 2, 24),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Consumer<CategoryTabsViewModel>(
          builder: (context, viewModel, _) {
            return Column(
              children: [
                _buildTabs(viewModel),
                _buildIconGrid(viewModel),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabs(CategoryTabsViewModel viewModel) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 0.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 12,
      ),
      itemCount: viewModel.icons.length,
      itemBuilder: (context, index) => _buildIconItem(viewModel.icons[index]),
    );
  }

  Widget _buildIconItem(CategoryIcon icon) {
    final words = icon.title.split(' ');
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 58,
          height: 58,
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
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  icon.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: words.map((word) => Container(
                  width: constraints.maxWidth,
                  child: Text(
                    word,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      height: 1.0,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                )).toList(),
              );
            }
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: tab.isSelected ? const Color(0xFFE7F0FF) : Colors.white,
              border: Border.all(
                color: const Color(0xFF001F54),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              tab.title,
              style: TextStyle(
                color: const Color(0xFF001F54),
                fontSize: 14,
                fontWeight: tab.isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
} 