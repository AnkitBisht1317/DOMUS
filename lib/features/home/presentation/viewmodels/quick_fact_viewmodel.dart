import 'package:flutter/material.dart';

import '../../domain/models/quick_fact_model.dart';

class QuickFactViewModel extends ChangeNotifier {
  final List<QuickFactModel> _facts = [
    QuickFactModel(
      title: 'Education boosts confidence.',
      description:
          'When students receive quality education, they gain not only knowledge but also the confidence to express ideas and solve real-world problems.',
    ),
    QuickFactModel(
      title: 'Healthy mind resides in a healthy body.',
      description:
          'Students who balance academics with physical activities tend to perform better and manage stress effectively.',
    ),
    QuickFactModel(
      title: 'Curiosity fuels learning.',
      description:
          'Encouraging students to ask questions and explore topics on their own leads to deeper understanding and long-term retention.',
    ),
    QuickFactModel(
      title: 'Consistency is key.',
      description:
          'Regular study habits, even for short durations, are more effective than last-minute cramming.',
    ),
    QuickFactModel(
      title: 'Collaborative learning enhances skills.',
      description:
          'Group discussions and teamwork help students learn from each other and develop communication skills.',
    ),
    QuickFactModel(
      title: 'Mistakes are stepping stones.',
      description:
          'Allowing room for failure encourages innovation and builds resilience in students.',
    ),
    QuickFactModel(
      title: 'Digital literacy is essential.',
      description:
          'In today’s world, students must be trained to use digital tools efficiently and responsibly for academic success.',
    ),
  ];

  List<QuickFactModel> get facts => _facts;

  void addFact(QuickFactModel fact) {
    _facts.add(fact);
    notifyListeners();
  }
}
