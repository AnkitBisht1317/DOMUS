import 'package:flutter/foundation.dart';
import '../../domain/models/test_series.dart';

class TestSeriesViewModel extends ChangeNotifier {
  TestSeries? _testSeries;
  
  TestSeries? get testSeries => _testSeries;

  TestSeriesViewModel() {
    _initializeTestSeries();
  }

  void _initializeTestSeries() {
    _testSeries = TestSeries(
      title: 'Test Series',
      types: [
        TestType(title: 'Free Mock'),
        TestType(title: 'Paid Mock'),
      ],
    );
    notifyListeners();
  }

  void onFreeMockTap() {
    // Implement free mock test functionality
  }

  void onPaidMockTap() {
    // Implement paid mock test functionality
  }
} 