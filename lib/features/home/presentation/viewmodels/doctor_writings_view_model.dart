import 'package:flutter/foundation.dart';
import '../../domain/models/doctor_writing.dart';

class DoctorWritingsViewModel extends ChangeNotifier {
  List<DoctorWriting> _writings = [];
  
  List<DoctorWriting> get writings => _writings;

  DoctorWritingsViewModel() {
    _initializeWritings();
  }

  void _initializeWritings() {
    _writings = [
      const DoctorWriting(
        title: "Card Title 1",
        imagePath: "assets/doctor1.png",
        description: "Description for card 1",
      ),
      const DoctorWriting(
        title: "Card Title 2",
        imagePath: "assets/doctor2.png",
        description: "Description for card 2",
      ),
      const DoctorWriting(
        title: "Card Title 3",
        imagePath: "assets/doctor3.png",
        description: "Description for card 3",
      ),
    ];
    notifyListeners();
  }
} 