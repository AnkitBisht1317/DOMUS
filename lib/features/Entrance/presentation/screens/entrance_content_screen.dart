import 'package:flutter/material.dart';
import '../../../shared/widgets/content_item_card.dart';
import '../../../shared/screenUI/lecture_player_screen.dart';
import '../../../shared/screenUI/tabbed_content_screen.dart';
import '../../../shared/screenUI/pdf_viewer_screen.dart';
import '../viewmodel/entrance_content_view_model.dart';
import '../../domain/model/entrance_content_model.dart';

class EntranceContentScreen extends StatefulWidget {
  final String entranceTitle;

  const EntranceContentScreen({
    Key? key,
    required this.entranceTitle,
  }) : super(key: key);

  @override
  State<EntranceContentScreen> createState() => _EntranceContentScreenState();
}

class _EntranceContentScreenState extends State<EntranceContentScreen> with SingleTickerProviderStateMixin {
  late EntranceContentViewModel viewModel;
  late EntranceContentCollection contentCollection;
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    viewModel = EntranceContentViewModel(entranceTitle: widget.entranceTitle);
    contentCollection = viewModel.getEntranceContent();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabbedContentScreen(
      title: widget.entranceTitle,
    );
  }
  
  Widget _buildTabButton(int index, String label) {
    bool isSelected = _tabController.index == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _tabController.animateTo(index);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF022150) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF022150),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  Widget _buildLectureTabContent() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: contentCollection.lectures.length,
      itemBuilder: (context, index) {
        final lecture = contentCollection.lectures[index];
        // Calculate a random progress value between 0.1 and 0.7 for demo purposes
        final progress = 0.1 + (index % 7) * 0.1;
        
        return ContentItemCard(
          title: lecture.title,
          imageUrl: lecture.imageUrl,
          duration: '1:15:59', // Example duration
          chapter: 'Physics',
          lectureNumber: 'Chapter ${index + 1}',
          progress: progress,
          isLocked: index > 2, // First 3 lectures are unlocked
          onTap: () {
            if (index <= 2) {
              _showLectureDetail(context, lecture.title, lecture.source ?? widget.entranceTitle);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This lecture is locked. Please purchase to unlock.')),
              );
            }
          },
          onMenuPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Menu pressed for ${lecture.title}')),
            );
          },
        );
      },
    );
  }
  
  Widget _buildNotesTabContent() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: contentCollection.notes.length,
      itemBuilder: (context, index) {
        final note = contentCollection.notes[index];
        // Calculate a random progress value between 0.1 and 0.7 for demo purposes
        final progress = 0.1 + (index % 7) * 0.1;
        
        return ContentItemCard(
          title: note.title,
          imageUrl: note.imageUrl,
          duration: '0:45:00', // Example duration
          chapter: 'Notes',
          lectureNumber: 'Chapter ${index + 1}',
          progress: progress,
          isLocked: false, // All notes are unlocked as per requirement
          onTap: () {
            _openPDFViewer(context, note.title);
          },
          onMenuPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Menu pressed for ${note.title}')),
            );
          },
        );
      },
    );
  }

  Widget _buildMCQsTabContent() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: contentCollection.mcqs.length,
      itemBuilder: (context, index) {
        final mcq = contentCollection.mcqs[index];
        // Calculate a random progress value between 0.1 and 0.7 for demo purposes
        final progress = 0.1 + (index % 7) * 0.1;
        
        return ContentItemCard(
          title: mcq.title,
          imageUrl: 'assets/physics.png',
          duration: '0:30:00',
          chapter: 'MCQs',
          lectureNumber: 'Set ${index + 1}',
          progress: progress,
          isLocked: false, // All MCQs are unlocked as per requirement
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening ${mcq.title}')),
            );
          },
          onMenuPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Menu pressed for ${mcq.title}')),
            );
          },
        );
      },
    );
  }

  void _showLectureDetail(BuildContext context, String title, String source) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LecturePlayerScreen(
          title: title,
          batchName: source,
          duration: '1:15:59', // Example duration
          progress: 0.3, // Example progress
        ),
      ),
    );
  }

  void _openPDFViewer(BuildContext context, String title) {
    // In a real app, you would pass the actual PDF path or URL
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(
          title: title,
          // For demo purposes, we're providing a sample PDF path
          // In a real app, you would get this from your data model
          pdfPath: 'assets/sample.pdf',
          // pdfUrl: 'https://example.com/pdf.pdf',
        ),
      ),
    ).then((_) {
      print('Returned from PDF viewer');
      // This will be called when returning from the PDF viewer
      print('Returned from PDF viewer');
    });
  }
}