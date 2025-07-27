import 'package:flutter/material.dart';

import '../../domain/model/course_wise_model.dart';
import '../viewmodels/course_wise_view_model.dart';
import '../widgets/coruse_wise_tile.dart';

class CourseWiseScreen extends StatelessWidget {
  final String courseTitle;

  const CourseWiseScreen({super.key, required this.courseTitle});

  @override
  Widget build(BuildContext context) {
    final viewModel = CourseWiseViewModel();
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
          courseTitle,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      body: FutureBuilder<List<CourseWiseModel>>(
        future: viewModel.fetchSubjects(courseTitle),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No subjects found"));
          }

          final subjects = snapshot.data!;
          return Container(
            width: screenWidth,
            height: screenHeight,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                return CoruseWiseTile(subject: subjects[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
