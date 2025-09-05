import 'package:flutter/material.dart';
import 'content_item_card.dart';

/// A reusable widget to display a list of content items
class ContentListView extends StatelessWidget {
  /// List of item titles
  final List<String> titles;
  
  /// Optional list of subtitles
  final List<String?>? subtitles;
  
  /// Optional list of sources
  final List<String?>? sources;
  
  /// Optional list of image URLs
  final List<String?>? imageUrls;
  
  /// Optional list of icons
  final List<IconData?>? icons;
  
  /// Optional callback when an item is tapped
  final Function(int)? onItemTap;
  
  /// Optional empty state message
  final String emptyStateMessage;

  const ContentListView({
    Key? key,
    required this.titles,
    this.subtitles,
    this.sources,
    this.imageUrls,
    this.icons,
    this.onItemTap,
    this.emptyStateMessage = 'No content available',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (titles.isEmpty) {
      return Center(
        child: Text(
          emptyStateMessage,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: titles.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return ContentItemCard(
          title: titles[index],
          subtitle: subtitles != null && subtitles!.length > index ? subtitles![index] : null,
          source: sources != null && sources!.length > index ? sources![index] : null,
          imageUrl: imageUrls != null && imageUrls!.length > index ? imageUrls![index] : null,
          icon: icons != null && icons!.length > index ? icons![index] : null,
          onTap: onItemTap != null ? () => onItemTap!(index) : null,
        );
      },
    );
  }
}