import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/test_series_view_model.dart';

class TestSeriesSection extends StatelessWidget {
  const TestSeriesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TestSeriesViewModel>(
      builder: (context, viewModel, _) {
        final testSeries = viewModel.testSeries;
        if (testSeries == null) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE8EEF9),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFD0D9E8),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    testSeries.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF001F54),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 45,
                          margin: const EdgeInsets.only(right: 8),
                          child: ElevatedButton(
                            onPressed: viewModel.onFreeMockTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF001F54),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Free Mock',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 45,
                          margin: const EdgeInsets.only(left: 8),
                          child: ElevatedButton(
                            onPressed: viewModel.onPaidMockTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF001F54),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Paid Mock',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 