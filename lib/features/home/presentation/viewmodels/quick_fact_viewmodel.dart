import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../domain/models/quick_fact_model.dart';

class QuickFactViewModel extends ChangeNotifier {
  final List<QuickFactModel> _facts = [];

  List<QuickFactModel> get facts => _facts;

  // Load facts from Firebase
  Future<void> loadFacts() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('quick_facts').get();

      _facts.clear(); // Clear previous data if any
      for (var doc in snapshot.docs) {
        _facts.add(QuickFactModel.fromMap(doc.data()));
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading facts: $e");
    }
  }
}
