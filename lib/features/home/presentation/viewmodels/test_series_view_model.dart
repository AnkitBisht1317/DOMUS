import 'package:domus/features/FreeMock/presentation/screen/free_mock_screen.dart';
import 'package:flutter/material.dart';

import '../../../PaidMock/presentation/screen/paid_mock.dart';
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

  void onFreeMockTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => const FreeMockScreen()), // your PaidMock screen
    );
  }

  void onPaidMockTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => const PaidMock()), // your PaidMock screen
    );
  }
}
