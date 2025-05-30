import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/doctor_writings_view_model.dart';
import 'doctor_writing_card.dart';

class DoctorWritingsSection extends StatelessWidget {
  const DoctorWritingsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 16),
              child: Text(
                "Doctor's Writings",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF001F54),
                ),
              ),
            ),
            Consumer<DoctorWritingsViewModel>(
              builder: (context, viewModel, child) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: viewModel.writings.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final writing = viewModel.writings[index];
                    return DoctorWritingCard(
                      writing: writing,
                      onTap: () {
                        // Handle card tap
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Handle View All tap
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF001F54),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 