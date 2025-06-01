import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/job_portal_view_model.dart';

class JobPortalScreen extends StatelessWidget {
  const JobPortalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<JobPortalViewModel>(
      builder: (context, viewModel, child) {
        final jobPortal = viewModel.jobPortal;
        if (jobPortal == null) return const SizedBox.shrink();

        return Scaffold(
          appBar: AppBar(
            title: Text(jobPortal.title),
            backgroundColor: const Color(0xFF001F54),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Image
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(jobPortal.carouselImages.first),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Job Listings Section (to be implemented)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Available Positions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF001F54),
                    ),
                  ),
                ),
                // Add job listings here
              ],
            ),
          ),
        );
      },
    );
  }
} 