import 'package:flutter/material.dart';
import '../../domain/models/question_of_day.dart';

class QOTDQuestionItem extends StatelessWidget {
  final Question question;
  final String logoAsset;
  final String date;

  const QOTDQuestionItem({
    Key? key,
    required this.question,
    required this.logoAsset,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF001F54),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Left side - Logo in white square with proper margin
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: SizedBox(
                  height: 28,
                  width: 28,
                  child: Image.asset(logoAsset),
                ),
              ),
            ),
          ),
          
          // Right side - Question text and actions
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Question text
                  Text(
                    question.question,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Date and action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Date
                      Text(
                        'Date: $date',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                      
                      // Action buttons
                      Row(
                        children: [
                          // WhatsApp share button
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          
                          const SizedBox(width: 8),
                          
                          // Bookmark button
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.bookmark_border,
                              color: Color(0xFF001F54),
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}