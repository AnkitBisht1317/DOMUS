import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/model/medicos_model.dart';

class MedicosViewModel {
  Future<List<Medico>> fetchMedicos() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('medicos_corner').get();
      return snapshot.docs.map((doc) => Medico.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error fetching medicos: $e');
      return [];
    }
  }
}
