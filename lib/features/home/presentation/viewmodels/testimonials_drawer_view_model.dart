import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../domain/models/testimonials_model.dart';

class TestimonialsDrawerViewModel extends ChangeNotifier {
  final List<DoctorModel> _doctors = [];
  bool _isLoading = true;

  List<DoctorModel> get doctors => _doctors;
  bool get isLoading => _isLoading;

  TestimonialsDrawerViewModel() {
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('testimonials').get();

      _doctors.clear();
      for (var doc in snapshot.docs) {
        _doctors.add(DoctorModel.fromMap(doc.data()));
      }
    } catch (e) {
      debugPrint("Error fetching doctors: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
