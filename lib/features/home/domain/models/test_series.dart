import 'dart:ui';

class TestSeries {
  final String title;
  final List<TestType> types;

  const TestSeries({
    required this.title,
    required this.types,
  });
}

class TestType {
  final String title;
  final VoidCallback? onTap;

  const TestType({
    required this.title,
    this.onTap,
  });
} 