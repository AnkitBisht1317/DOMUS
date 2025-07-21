import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/about_view_model.dart';

class AboutContent extends StatelessWidget {
  const AboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AboutViewModel>(context);
    final paragraphs = viewModel.paragraphs;
    final width = MediaQuery.of(context).size.width;

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  'AIM Homoeopathy',
                  style: TextStyle(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quest for Excellence',
                  style: TextStyle(
                    fontSize: width * 0.038,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...paragraphs.map((para) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  para.paragraph,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: width * 0.038,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
