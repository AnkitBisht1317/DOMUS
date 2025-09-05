import 'package:flutter/material.dart';

/// A reusable tabbed content container that displays content with tabs
/// This widget is designed to be used across multiple screens with different content
class TabbedContentContainer extends StatefulWidget {
  /// The title of the container
  final String title;
  
  /// Optional subtitle to display below the title
  final String? subtitle;
  
  /// List of tab names to display
  final List<String> tabNames;
  
  /// List of widgets to display for each tab
  final List<Widget> tabContents;
  
  /// Initial tab index to select
  final int initialTabIndex;
  
  /// Optional callback when tab changes
  final Function(int)? onTabChanged;

  const TabbedContentContainer({
    Key? key,
    required this.title,
    this.subtitle,
    required this.tabNames,
    required this.tabContents,
    this.initialTabIndex = 0,
    this.onTabChanged,
  }) : assert(tabNames.length == tabContents.length, 'Tab names and contents must have the same length'),
       super(key: key);

  @override
  State<TabbedContentContainer> createState() => _TabbedContentContainerState();
}

class _TabbedContentContainerState extends State<TabbedContentContainer> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabNames.length,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.onTabChanged?.call(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header section
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.subtitle != null) ...[  
                const SizedBox(height: 4),
                Text(
                  widget.subtitle!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // Tab Bar
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white24,
                width: 1,
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            tabs: widget.tabNames.map((name) => Tab(text: name)).toList(),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        
        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabContents,
          ),
        ),
      ],
    );
  }
}