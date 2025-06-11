import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/about_view_model.dart';
import '../widgets/about_content.dart';

class AboutDrawer extends StatelessWidget {
  const AboutDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider(
      create: (_) => AboutViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFF022150),
        appBar: AppBar(
          backgroundColor: const Color(0xFF022150),
          elevation: 0,
          leading: IconButton(
            icon:
                Icon(Icons.arrow_back, color: Colors.white, size: width * 0.06),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              Text(
                'About Us',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.05,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: height * 0.01),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: const SingleChildScrollView(
                  child: AboutContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
