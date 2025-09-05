import 'package:flutter/material.dart';

/// A reusable widget for lecture action buttons
/// Based on the Figma design for NTET LECTURE
class LectureActionButtons extends StatelessWidget {
  /// Callback when chat room button is pressed
  final VoidCallback? onChatRoomPressed;
  
  /// Callback when doubt button is pressed
  final VoidCallback? onDoubtPressed;
  
  /// Callback when feedback button is pressed
  final VoidCallback? onFeedbackPressed;
  
  /// Callback when report button is pressed
  final VoidCallback? onReportPressed;

  const LectureActionButtons({
    Key? key,
    this.onChatRoomPressed,
    this.onDoubtPressed,
    this.onFeedbackPressed,
    this.onReportPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.chat,
            label: 'Chat Room',
            onPressed: onChatRoomPressed,
          ),
          _buildActionButton(
            icon: Icons.help_outline,
            label: 'Doubt',
            onPressed: onDoubtPressed,
          ),
          _buildActionButton(
            icon: Icons.feedback_outlined,
            label: 'Feedback',
            onPressed: onFeedbackPressed,
          ),
          _buildActionButton(
            icon: Icons.report_outlined,
            label: 'Report',
            onPressed: onReportPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: const Color(0xFF001F54),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF001F54),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}