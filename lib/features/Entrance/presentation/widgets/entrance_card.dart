import 'package:domus/features/Entrance/domain/model/entrance_model.dart';
import 'package:domus/features/Entrance/presentation/screens/entrance_content_screen.dart';
import 'package:flutter/material.dart';

class EntranceCard extends StatelessWidget {
  final Entran entran;
  const EntranceCard({Key? key, required this.entran}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EntranceContentScreen(
              entranceTitle: entran.title,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xB2204771),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: width * 0.08,
              backgroundImage: AssetImage(entran.imageUrl),
            ),
            const SizedBox(height: 8),
            Text(
              entran.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.035,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
