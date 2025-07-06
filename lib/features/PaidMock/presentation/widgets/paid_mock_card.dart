import 'package:flutter/material.dart';

import '../../domain/model/paid_mock_model.dart';

class PaidMockCard extends StatelessWidget {
  final PaidMockModel mock;

  const PaidMockCard({super.key, required this.mock});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor:
            0.94, // ⬅️ 94% of screen width (reduce this to decrease length more)
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: Row(
              children: [
                Image.asset(
                  mock.imagePath,
                  width: screenWidth * 0.1,
                  height: screenWidth * 0.1,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    mock.title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
