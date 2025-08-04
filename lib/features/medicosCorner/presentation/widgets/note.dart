import 'package:domus/features/medicosCorner/domain/model/Subject_wise_note.dart';
import 'package:domus/features/medicosCorner/presentation/widgets/purchase.dart';
import 'package:flutter/material.dart';

import '../screens/pdf_viewer.dart';
import 'bookmark.dart';

class Note extends StatelessWidget {
  final SubjectWiseNotes notes;
  const Note({super.key, required this.notes});

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
                if (!notes.isLocked) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewer(
                        title: notes.title,
                        pdfPath: notes.pdfPath,
                      ),
                    ),
                  );
                } else {
                  // Show purchase dialog for locked notes
                  Purchase.show(context);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // PDF Icon using aphorism.png
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/aphorism.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Note details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notes.title,
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
          // Lock overlay for locked notes
          if (notes.isLocked)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Show purchase dialog for locked notes
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
