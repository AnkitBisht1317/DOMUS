import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/lectures_view_model.dart';
import 'lecture_card.dart';

class MyLecturesSection extends StatelessWidget {
  const MyLecturesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LecturesViewModel>(
      builder: (context, viewModel, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "My Lectures",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF001F54),
                ),
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.lectures.length,
              itemBuilder: (context, index) {
                final lecture = viewModel.lectures[index];
                return LectureCard(
                  lecture: lecture,
                  onMoreTap: () => viewModel.onMoreTap(index),
                );
              },
            ),
          ],
        );
      },
    );
  }
} 