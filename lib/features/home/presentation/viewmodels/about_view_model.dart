import 'package:flutter/material.dart';

import '../../domain/models/about_model.dart';

class AboutViewModel extends ChangeNotifier {
  final List<AboutModel> _paragraphs = [
    AboutModel(
      paragraph:
          'At Aim Homoeopathy, we are committed to restoring health and wellness through the trusted principles of classical homeopathy.',
    ),
    AboutModel(
      paragraph:
          'Established with a vision to offer safe, effective, and holistic healing, our clinic combines traditional knowledge with modern practices to address the root causes of illness rather than just symptoms.',
    ),
    AboutModel(
      paragraph:
          'With a focus on individual care, our experienced homoeopaths design personalized treatment plans that align with each patient\'s unique constitution.',
    ),
    AboutModel(
      paragraph:
          'At Vision 2.3, we continue to evolve, ensuring high-quality care, transparency, and compassionate service.',
    ),
    AboutModel(
      paragraph:
          'Whether you\'re seeking relief from chronic ailments or looking to boost overall well-being, Aim Homoeopathy is your trusted partner on the path to natural healing.',
    ),
  ];

  List<AboutModel> get paragraphs => _paragraphs;
}
