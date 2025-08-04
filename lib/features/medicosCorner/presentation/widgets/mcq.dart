import 'package:domus/features/medicosCorner/domain/model/subject_wise_mcq.dart';
import 'package:domus/features/medicosCorner/presentation/widgets/purchase.dart';
import 'package:flutter/material.dart';

import 'bookmark.dart';

class Mcq extends StatelessWidget {
  final SubjectWiseMCQ mcq;
  const Mcq({super.key, required this.mcq});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF204771),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (!mcq.isLocked) {
                  // Navigate to MCQ test screen (to be implemented)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('MCQ Test will be implemented soon'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                } else {
                  // Show purchase dialog for locked MCQs
                  Purchase.show(context);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // MCQ Icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/exam.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // MCQ details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mcq.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bookmark icon
                    Bookmark(),
                  ],
                ),
              ),
            ),
          ),
          // Lock overlay for locked MCQs
          if (mcq.isLocked)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Show purchase dialog for locked MCQs
                    Purchase.show(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.amber[700],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 20,
                        ),
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
