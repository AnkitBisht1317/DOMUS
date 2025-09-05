import 'package:flutter/material.dart';

/// A reusable card component for displaying content items
/// This can be used for lectures, notes, MCQs, etc.
class ContentItemCard extends StatelessWidget {
  /// The title of the content item
  final String title;
  
  /// Optional subtitle or description
  final String? subtitle;
  
  /// Optional source or author information
  final String? source;
  
  /// Optional icon to display
  final IconData? icon;
  
  /// Optional image URL to display
  final String? imageUrl;
  
  /// Optional callback when the card is tapped
  final VoidCallback? onTap;
  
  /// Optional duration text (e.g. "1:15:59")
  final String? duration;
  
  /// Optional callback when menu button is pressed
  final VoidCallback? onMenuPressed;
  
  /// Whether the content is locked
  final bool isLocked;
  
  /// Optional chapter name
  final String? chapter;
  
  /// Optional lecture number
  final String? lectureNumber;
  
  /// Progress value between 0.0 and 1.0
  final double progress;

  const ContentItemCard({
    Key? key,
    required this.title,
    this.subtitle,
    this.source,
    this.icon,
    this.imageUrl,
    this.onTap,
    this.duration,
    this.onMenuPressed,
    this.isLocked = false,
    this.chapter,
    this.lectureNumber,
    this.progress = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // Reduced margin for more compact layout
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 31, 70, 110),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          // Main content row
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  // Lecture image - made larger
                  Container(
                    width: 100, // Increased from 80
                    height: 70, // Adjusted height
                    padding: const EdgeInsets.all(4), // Reduced padding
                    child: imageUrl != null
                      ? Image.asset(
                          imageUrl!,
                          fit: BoxFit.contain,
                        )
                      : Image.asset(
                          'assets/books.png',
                          fit: BoxFit.contain,
                        ),
                  ),
                  
                  // Lecture details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chapter != null && lectureNumber != null
                              ? "$chapter || $lectureNumber"
                              : title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Progress indicator
                          if (!isLocked && duration != null) ...[  
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF001F54)),
                              minHeight: 5,
                            ),
                          ],
                          const SizedBox(height: 8),
                          Text(
                            duration ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Three-dot menu icon
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: onMenuPressed ?? () {},
                  ),
                ],
              ),
            ),
          ),
          
          // Lock overlay for locked lectures
          if (isLocked)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5), // Semi-transparent white overlay
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.lock,
                        color: Colors.grey[800],
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}