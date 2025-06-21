

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import '../../domain/models/question_of_day.dart';
import '../screens/qotd_detail_screen.dart';
import '../screens/qotd_explanation_screen.dart';

class QuestionViewModel extends ChangeNotifier {
  QuestionOfDay? _questionOfDay;
  
  QuestionOfDay? get questionOfDay => _questionOfDay;

  QuestionViewModel() {
    _initializeQuestion();
  }

  void _initializeQuestion() {
    _questionOfDay = QuestionOfDay(
      question: 'An electron and alpha particle have the same de-Broglie wavelength associated with them. How are their kinetic energies related to each other? (Delhi 2008)',
      date: 'May 04',
      options: [
        QuestionOption(prefix: 'A', text: 'KE₁ = KE₂'),
        QuestionOption(prefix: 'B', text: 'KE₁ > KE₂'),
        QuestionOption(prefix: 'C', text: 'KE₁ < KE₂'),
        QuestionOption(prefix: 'D', text: 'KE₁ = (m₁/m₂) × KE₂'),
      ],
      description: 'The de-Broglie wavelength of a particle is given by the formula: λ = h/p\n\nWhere:\n• λ(lambda) is the de-Broglie wavelength\n• h is Planck\'s constant\n• p is the momentum of the particle\n\nSince momentum p=√(2mKE) = √(2m×2mk), where:\n• m is the mass of the particle\n• KE is the kinetic energy\n\nTherefore, we can write:\n\nIf an electron and alpha particle have the same de-Broglie wavelength, their kinetic energies are inversely proportional to their masses.\n\nSince the mass of an alpha particle is much greater than the mass of an electron (approximately m_alpha ≈ 4 times 1836 × m_electron), the kinetic energy of the alpha particle is much smaller than that of the electron.',
    );
    notifyListeners();
  }

  void explainAnswer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: this,
          child: const QOTDExplanationScreen(),
        ),
      ),
    );
  }

  // In the showMore method
  void showMore(BuildContext context) {
    // Navigate to the QOTD detail screen with the current ViewModel instance
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: this,
          child: const QOTDDetailScreen(),
        ),
      ),
    );
  }
}