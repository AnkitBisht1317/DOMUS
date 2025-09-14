import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/widgets.dart';
import '../widgets/pdf_controls.dart';
// Temporarily comment out these imports to see if they're causing the build issue
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

class PDFViewerScreen extends StatefulWidget {
  final String title;
  final String? pdfPath;
  final String? pdfUrl;

  const PDFViewerScreen({
    Key? key,
    required this.title,
    this.pdfPath,
    this.pdfUrl,
  }) : super(key: key);

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  bool _isLoading = true;
  String? _localPdfPath;
  int _totalPages = 0;
  int _currentPage = 0;
  bool _swipeHorizontal = false;
  PDFViewController? _pdfViewController;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  static const double _minScale = 1.0;
  static const double _maxScale = 3.0;
  // Orientation tracking
  Orientation? _currentOrientation;
  // Controller for interactive viewer
  late TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _initPDF();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  Future<void> _initPDF() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Handle PDF from assets or file path
      if (widget.pdfPath != null && widget.pdfPath!.startsWith('assets/')) {
        // For assets, we need to copy the asset to a local file
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/sample.pdf');
        
        try {
          // Use rootBundle to properly load the asset
          final ByteData data = await rootBundle.load(widget.pdfPath!);
          final List<int> bytes = data.buffer.asUint8List();
          
          // Write the asset to a temporary file
          await file.writeAsBytes(bytes);
          
          setState(() {
            _localPdfPath = file.path;
            print('PDF loaded from assets: ${widget.pdfPath}');
          });
        } catch (e) {
          print('Error loading asset PDF file: $e');
          // Try to load a default PDF if the specified one fails
          await _loadDefaultPdf();
        }
      } else if (widget.pdfUrl != null) {
        // TODO: Implement URL download functionality
        print('PDF URL provided but download not implemented yet: ${widget.pdfUrl}');
        await _loadDefaultPdf();
      } else if (widget.pdfPath != null) {
        try {
          // Check if the file exists and is valid
          final file = File(widget.pdfPath!);
          if (await file.exists()) {
            // Try to validate the PDF file
            setState(() {
              _localPdfPath = widget.pdfPath;
              print('Using direct PDF path: ${widget.pdfPath}');
            });
          } else {
            // File doesn't exist, try to load default PDF from assets
            print('PDF file does not exist: ${widget.pdfPath}');
            await _loadDefaultPdf();
          }
        } catch (e) {
          print('Error checking file: $e');
          await _loadDefaultPdf();
        }
      } else {
        // No PDF provided, try to load default PDF from assets
        print('No PDF path provided, trying to load default PDF');
        await _loadDefaultPdf();
      }
      
      // Set initial page count
      setState(() {
        _totalPages = 10; // Default value until actual PDF is loaded
        _currentPage = 1;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading PDF: $e');
      print('Stack trace: ${e.toString()}');
      setState(() {
        _isLoading = false;
        _localPdfPath = null; // Force showing the sample content on error
      });
    }
  }
  
  // Helper method to load default PDF
  Future<void> _loadDefaultPdf() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/default.pdf');
      
      // Use the specific PDF path requested by the user
      final String pdfAssetPath = 'assets/pdfs/sample_notes.pdf';
      print('Loading PDF from asset: $pdfAssetPath');
      
      final ByteData defaultData = await rootBundle.load(pdfAssetPath);
      final List<int> defaultBytes = defaultData.buffer.asUint8List();
      await file.writeAsBytes(defaultBytes);
      
      setState(() {
        _localPdfPath = file.path;
        print('Loaded default PDF: $pdfAssetPath');
      });
    } catch (defaultError) {
      print('Error loading default PDF: $defaultError');
      setState(() {
        _localPdfPath = null; // Force showing the sample content
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building PDF Viewer with isLoading: $_isLoading, localPdfPath: $_localPdfPath');
    
    // Check for orientation changes
    final currentOrientation = MediaQuery.of(context).orientation;
    if (_currentOrientation != currentOrientation) {
      _currentOrientation = currentOrientation;
      
      // Apply default zoom for landscape mode
      if (currentOrientation == Orientation.landscape && _transformationController.value.getMaxScaleOnAxis() < 1.5) {
        // Use a slightly higher zoom for landscape to improve readability
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Create a Matrix4 with scale 1.5
          final Matrix4 newMatrix = Matrix4.identity()..scale(1.5);
          _transformationController.value = newMatrix;
          setState(() {
            _currentScale = 1.5;
          });
        });
      }
    }
    return Scaffold(
      backgroundColor: const Color(0xFF001F54),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F54),
        elevation: 0,
        title: Container(
          width: double.infinity,
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.visible,
            maxLines: 2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Controls and page indicator - This stays fixed at the top
                  PDFControls(
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                    pdfViewController: _pdfViewController,
                    currentScale: _currentScale,
                    onZoomChanged: (double newScale) {
                      setState(() {
                        _currentScale = newScale;
                        // Update transformation matrix
                        final Matrix4 newMatrix = Matrix4.identity()..scale(_currentScale);
                        _transformationController.value = newMatrix;
                      });
                    },
                    onDownload: _localPdfPath != null ? () async {
                      // Implement download functionality
                      try {
                        final directory = await getExternalStorageDirectory();
                        if (directory != null) {
                          final fileName = widget.title.replaceAll(' ', '_') + '.pdf';
                          final targetPath = '${directory.path}/$fileName';
                          
                          // Copy the PDF file to downloads directory
                          final File sourceFile = File(_localPdfPath!);
                          final File targetFile = File(targetPath);
                          await sourceFile.copy(targetPath);
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('PDF saved to $targetPath'))
                          );
                        }
                      } catch (e) {
                        print('Error downloading PDF: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to download PDF'))
                        );
                      }
                    } : null,
                  ),
                  // PDF Viewer - This is scrollable
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _localPdfPath != null
                            ? SizedBox(
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.height * 0.7,
                                      child: PDFView(
                                        filePath: _localPdfPath!,
                                        enableSwipe: true,
                                        swipeHorizontal: false,
                                        autoSpacing: true,
                                        pageFling: true,
                                        pageSnap: false,
                                        defaultPage: _currentPage - 1,
                                        fitPolicy: FitPolicy.BOTH,
                                        preventLinkNavigation: false,
                                        onRender: (pages) {
                                          print('PDF rendered with $pages pages');
                                          setState(() {
                                            _totalPages = pages ?? 0;
                                            _currentPage = 1;
                                          });
                                        },
                                      onError: (error) {
                                        print('PDF error: $error');
                                        // Handle error silently without showing SnackBar
                                        if (error.toString().contains('java.io.IOException') || 
                                            error.toString().contains('cannot create document')) {
                                          setState(() {
                                            _localPdfPath = null; // Show sample content instead
                                          });
                                        }
                                      },
                                      onPageError: (page, error) {
                                        print('PDF page $page error: $error');
                                        // Handle page error silently without showing SnackBar
                                      },
                                      onViewCreated: (PDFViewController pdfViewController) {
                                        setState(() {
                                          _pdfViewController = pdfViewController;
                                          print('PDF view controller created');
                                        });
                                      },
                                      onPageChanged: (int? page, int? total) {
                                        if (page != null) {
                                          setState(() {
                                            _currentPage = page + 1; // Adjust for 0-based index
                                            print('Page changed to ${page + 1} of $total');
                                          });
                                        }
                                      },
                                    ),
                                  )
                            : SingleChildScrollView(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Display a sample PDF content when no PDF is available
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Class 11',
                                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'Physical World',
                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'Notes Physics Chapter 1',
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 24),
                                            const Text(
                                              '1. Science',
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'Science is a systematic and organised attempt to acquire knowledge about the surroundings through observations, experiments and verifications.',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              '2. Scientific Method',
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'Several inter-related steps are involved in scientific method. Some of the most significant steps are as follows:',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(height: 8),
                                            const Padding(
                                              padding: EdgeInsets.only(left: 16.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('• The systematic observations', style: TextStyle(fontSize: 16)),
                                                  Text('• Reasoning', style: TextStyle(fontSize: 16)),
                                                  Text('• Mathematical modelling', style: TextStyle(fontSize: 16)),
                                                  Text('• Theoretical prediction', style: TextStyle(fontSize: 16)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // No bottom navigation bar needed as per the design
      /*bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF001F54)),
              onPressed: _currentPage > 1
                  ? () {
                      if (_pdfViewController != null) {
                        _pdfViewController!.setPage(_currentPage - 2);
                      }
                    }
                  : null,
            ),*/
            /*Text(
              'Page $_currentPage of $_totalPages',
              style: const TextStyle(
                color: Color(0xFF001F54),
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF001F54)),
              onPressed: _currentPage < _totalPages
                  ? () {
                      if (_pdfViewController != null) {
                        _pdfViewController!.setPage(_currentPage);
                      }
                    }
                  : null,
            ),
          ],
        ),
      ),*/
    );
  }
}