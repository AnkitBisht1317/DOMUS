import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../domain/models/about_model.dart';

class AboutViewModel extends ChangeNotifier {
  final List<AboutModel> _paragraphs = [];
  bool _isLoading = false;

  List<AboutModel> get paragraphs => _paragraphs;
  bool get isLoading => _isLoading;

  AboutViewModel() {
    fetchParagraphs();
  }

  Future<void> fetchParagraphs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('about').get();
      _paragraphs.clear();
      _paragraphs
          .addAll(snapshot.docs.map((doc) => AboutModel.fromMap(doc.data())));
    } catch (e) {
      print('Error fetching about paragraphs: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
