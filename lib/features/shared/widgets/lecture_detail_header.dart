import 'package:flutter/material.dart';

/// A reusable header widget for lecture detail screens
/// Based on the Figma design for NTET LECTURE
class LectureDetailHeader extends StatelessWidget {
  /// The title of the lecture
  final String title;
  
  /// The source or batch information
  final String source;
  
  /// Optional callback when bookmark button is pressed
  final VoidCallback? onBookmarkPressed;
  
  /// Optional callback when sound button is pressed
  final VoidCallback? onSoundPressed;
  
  /// Whether the lecture is bookmarked
  final bool isBookmarked;
  
  /// Whether the sound is on
  final bool isSoundOn;

  const LectureDetailHeader({
    Key? key,
    required this.title,
    required this.source,
    this.onBookmarkPressed,
    this.onSoundPressed,
    this.isBookmarked = false,
    this.isSoundOn = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF001F54),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              
              // Action buttons
              Row(
                children: [
                  // Sound button
                  IconButton(
                    icon: Icon(
                      isSoundOn ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white,
                    ),
                    onPressed: onSoundPressed,
                  ),
                  
                  // Bookmark button
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                    ),
                    onPressed: onBookmarkPressed,
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Title
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Source
          Text(
            source,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}