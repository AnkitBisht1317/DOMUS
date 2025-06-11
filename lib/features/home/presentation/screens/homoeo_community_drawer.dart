import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/community_view_model.dart';
import '../widgets/community_tile.dart';

class HomoeoCommunityDrawer extends StatelessWidget {
  const HomoeoCommunityDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (_) => CommunityViewModel(),
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
            'Homoeo Community',
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
                child: Consumer<CommunityViewModel>(
                  builder: (context, viewModel, _) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      itemCount: viewModel.items.length,
                      itemBuilder: (context, index) {
                        return CommunityTile(item: viewModel.items[index]);
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
