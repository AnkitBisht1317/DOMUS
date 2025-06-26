import 'package:flutter/material.dart';

import '../../domain/model/medicos_model.dart';

class MedicosCard extends StatelessWidget {
  final Medico medico;

  const MedicosCard({Key? key, required this.medico}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
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
            backgroundImage: AssetImage(medico.imageUrl),
          ),
          const SizedBox(height: 8),
          Text(
            medico.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
