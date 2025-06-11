import 'package:domus/features/home/presentation/widgets/aim_academy_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/aim_academy_view_model.dart';

class AimAcademyDrawer extends StatelessWidget {
  const AimAcademyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (_) => AimAcademyViewModel(),
      child: Scaffold(
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
            'AIM Academy',
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Consumer<AimAcademyViewModel>(
                  builder: (context, viewModel, _) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 16),
                      itemCount: viewModel.videos.length,
                      itemBuilder: (context, index) {
                        return AimAcademyTile(video: viewModel.videos[index]);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
