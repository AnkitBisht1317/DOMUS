import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/blue_white_container.dart';
import '../viewmodels/ntet_view_model.dart';
import '../../domain/models/ntet_lecture.dart';

class NTETScreen extends StatelessWidget {
  const NTETScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NTETViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFF001F54),
        body: Column(
          children: [
            // Top container with title and back button
            Container(
              width: double.infinity,
              color: const Color(0xFF001F54),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                bottom: 16,
                left: 16,
                right: 16,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'NTET',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content container with rounded top corners
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
                      child: Consumer<NTETViewModel>(
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
                    
                    // Lectures list
                    Expanded(
                      child: Consumer<NTETViewModel>(
                        builder: (context, viewModel, _) {
                          if (viewModel.selectedTab == "Lecture") {
                            return ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: viewModel.lectures.length,
                              itemBuilder: (context, index) {
                                return _buildLectureItem(viewModel.lectures[index]);
                              },
                            );
                          } else {
                            return Center(
                              child: Text(
                                "${viewModel.selectedTab} content coming soon",
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String title, NTETViewModel viewModel) {
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

  Widget _buildLectureItem(NTETLecture lecture) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // Reduced margin for more compact layout
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
          Row(
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
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10), // Adjusted padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${lecture.chapter} || ${lecture.lectureNumber}", // Combined format as shown in screenshot
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Progress indicator
                      if (!lecture.isLocked) ...[  
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: lecture.progress,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF001F54)),
                          minHeight: 5,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        lecture.duration,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Menu icon
              Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          
          // Lock overlay for locked lectures
          if (lecture.isLocked)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5), // Semi-transparent white overlay
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
        ],
      ),
    );
  }
}