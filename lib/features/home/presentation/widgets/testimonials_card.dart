import 'package:flutter/material.dart';

import '../../domain/models/testimonials_model.dart';

class TestimonialsCard extends StatelessWidget {
  final DoctorModel doctor;
  const TestimonialsCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.08,
                  backgroundImage: NetworkImage(doctor.profileImage),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    doctor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildLabeledLine('Subject', doctor.subject),
            _buildLabeledLine('Qualification', doctor.qualification),
            _buildLabeledLine('Experience', doctor.experience),
            _buildLabeledLine('Specialization', doctor.specialization),
            _buildLabeledLine('Teaching Style', doctor.teachingStyle),
            const SizedBox(height: 10),
            const Text(
              'Achievements:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ...doctor.achievements.map(
              (a) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• "),
                  Expanded(child: Text(a)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label :",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
