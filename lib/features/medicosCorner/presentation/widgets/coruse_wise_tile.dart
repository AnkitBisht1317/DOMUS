import 'package:flutter/material.dart';

import '../../domain/model/course_wise_model.dart';

class CoruseWiseTile extends StatelessWidget {
  final CourseWiseModel subject;
  const CoruseWiseTile({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF204771),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(subject.imageUrl),
            radius: width * 0.06,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              subject.title, // This is your subject name
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
