import 'package:flutter/material.dart';

import '../../domain/model/medicos_model.dart';
import '../viewmodels/medicos_view_model.dart';
import '../widgets/medicos_card.dart';

class MedicosCorner extends StatelessWidget {
  const MedicosCorner({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = MedicosViewModel();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
          'Medicos Corner',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      body: FutureBuilder<List<Medico>>(
        future: viewModel.fetchMedicos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
                child: Text("No data found",
                    style: TextStyle(color: Colors.white)));
          }

          final medicos = snapshot.data!;
          return Column(
            children: [
              SizedBox(height: screenHeight * 0.01),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: GridView.builder(
                    itemCount: medicos.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      return MedicosCard(medico: medicos[index]);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
