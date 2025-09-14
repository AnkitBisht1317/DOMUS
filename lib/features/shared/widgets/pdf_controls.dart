import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final PDFViewController? pdfViewController;
  final Function(double) onZoomChanged;
  final double currentScale;
  final VoidCallback? onDownload;

  const PDFControls({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.pdfViewController,
    required this.onZoomChanged,
    required this.currentScale,
    this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // Page counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              'Page $currentPage of $totalPages',
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
          ),

          // Control buttons
          const SizedBox(width: 20),
          // Zoom in button
          IconButton(
            icon: const Icon(Icons.zoom_in, color: Color(0xFF001F54)),
            onPressed: () {
              // Increase scale by 0.25 but don't exceed max scale
              const double maxScale = 3.0;
              double newScale = currentScale + 0.25;
              if (newScale <= maxScale) {
                onZoomChanged(newScale);
              }
            },
          ),
          // Zoom out button
          IconButton(
            icon: const Icon(Icons.zoom_out, color: Color(0xFF001F54)),
            onPressed: () {
              // Decrease scale by 0.25 but don't go below min scale
              const double minScale = 1.0;
              double newScale = currentScale - 0.25;
              if (newScale >= minScale) {
                onZoomChanged(newScale);
              }
            },
          ),
          // Download button
          if (onDownload != null)
            IconButton(
              icon: const Icon(Icons.download, color: Color(0xFF001F54)),
              onPressed: onDownload,
            ),
        ],
      ),
    );
  }
}