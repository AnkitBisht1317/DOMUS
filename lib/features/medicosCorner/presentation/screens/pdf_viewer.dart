import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class PdfViewer extends StatefulWidget {
  final String title;
  final String pdfPath;

  const PdfViewer({
    Key? key,
    required this.title,
    required this.pdfPath,
  }) : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  String? localPath;
  bool isLoading = true;
  int totalPages = 0;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  Future<void> loadPDF() async {
    // In a real app, you would load the PDF from Firebase Storage or other source
    // For this example, we'll simulate loading by showing a loading state
    setState(() {
      isLoading = true;
    });

    try {
      // Simulate loading delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real implementation, you would download the PDF here
      // For now, we'll just set a dummy path
      final directory = await getApplicationDocumentsDirectory();
      localPath = '${directory.path}/dummy.pdf';

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F54),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading PDF...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF bookmarked')),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : localPath == null
              ? const Center(child: Text('Failed to load PDF'))
              : Stack(
                  children: [
                    // This is a placeholder for the actual PDF viewer
                    // In a real implementation with actual PDF files, you would use:
                    // PDFView(
                    //   filePath: localPath!,
                    //   onViewCreated: (controller) {},
                    //   onPageChanged: (page, total) {
                    //     setState(() {
                    //       currentPage = page!;
                    //       totalPages = total!;
                    //     });
                    //   },
                    // ),

                    // For now, we'll show a placeholder
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.picture_as_pdf,
                            size: 100,
                            color: Color(0xFF001F54),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'PDF: ${widget.pdfPath}',
                            style: const TextStyle(color: Color(0xFF001F54)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Page: ${currentPage + 1} / $totalPages',
                            style: const TextStyle(color: Color(0xFF001F54)),
                          ),
                        ],
                      ),
                    ),

                    // Page navigation buttons
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // In a real implementation, this would navigate to previous page
                              if (currentPage > 0) {
                                setState(() {
                                  currentPage--;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF001F54),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Previous'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              // In a real implementation, this would navigate to next page
                              if (currentPage < 9) {
                                // Simulating 10 pages
                                setState(() {
                                  currentPage++;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF001F54),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Next'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
