import 'package:domus/features/medicosCorner/domain/model/subject_wise_model.dart';
import 'package:domus/features/medicosCorner/presentation/viewmodels/subject_wise_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/bookmark.dart';
import '../widgets/purchase.dart';

class SubjectWiseScreen extends StatelessWidget {
  final String subjectTitle;

  const SubjectWiseScreen({super.key, required this.subjectTitle});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF022150),
      appBar: AppBar(
        backgroundColor: const Color(0xFF022150),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.white, size: screenWidth * 0.06),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          subjectTitle,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.01),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Tab buttons
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Consumer<SubjectWiseViewModel>(
                      builder: (context, viewModel, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildTabButton(context, "Lecture", viewModel),
                            _buildTabButton(context, "Notes", viewModel),
                            _buildTabButton(context, "MCQs", viewModel),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
      BuildContext context, String title, SubjectWiseViewModel viewModel) {
    final isSelected = viewModel.selectedTab == title;

    return Container(
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? const Color(0xFF001F54) : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => viewModel.changeTab(title),
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFF001F54) : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLectureItem(SubjectWiseModel subject, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          bottom: 12), // Reduced margin for more compact layout
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 31, 70, 110),
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
              onTap: () {
                if (subject.isLocked) {
                  // Show purchase dialog for locked lectures
                  Purchase.show(context);
                } else {
                  // Navigate to lecture view or play lecture
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Playing lecture...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  // Lecture image - made larger
                  Container(
                    width: 100, // Increased from 80
                    height: 70, // Increased from 80
                    padding: const EdgeInsets.all(4), // Reduced padding
                    child: Image.asset(
                      'assets/physics.png',
                      fit: BoxFit.fill,
                    ),
                  ),

                  // Lecture details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10), // Adjusted padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${subject.chapter} || ${subject.lectureNumber}", // Combined format as shown in screenshot
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          // Progress indicator
                          if (!subject.isLocked) ...[
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: subject.progress,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  const Color(0xFF001F54)),
                              minHeight: 5,
                            ),
                          ],
                          const SizedBox(height: 8),
                          Text(
                            subject.duration,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bookmark button instead of menu icon
                  Bookmark(),
                ],
              ),
            ),
          ),

          // Lock overlay for locked lectures
          if (subject.isLocked)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Show purchase dialog for locked lectures
                    Purchase.show(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.5), // Semi-transparent white overlay
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
