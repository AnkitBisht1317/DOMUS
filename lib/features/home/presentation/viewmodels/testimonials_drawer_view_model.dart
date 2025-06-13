import 'package:flutter/material.dart';

import '../../domain/models/testimonials_model.dart';

class TestimonialsDrawerViewModel extends ChangeNotifier {
  final List<DoctorModel> _doctors = [
    DoctorModel(
      name: 'A - Doctor Profile 1',
      subject: 'Biology',
      profileImage: 'assets/testimonials.png',
      qualification: 'MBBS, MD (Physiology)',
      experience: '8+ years of teaching NEET aspirants',
      specialization: 'Human Physiology & Genetics',
      teachingStyle: 'Concept-based learning with real-life examples',
      achievements: [
        'Mentored 5000+ students',
        '200+ NEET selections under his guidance',
        'Guest Lecturer at Medical Entrance Seminars',
      ],
    ),
    DoctorModel(
      name: 'B - Doctor Profile 2',
      subject: 'Chemistry',
      profileImage: 'assets/testimonials.png',
      qualification: 'M.Sc, PhD (Chemistry)',
      experience: '10+ years of mentoring NEET students',
      specialization: 'Organic Chemistry',
      teachingStyle: 'Interactive problem-solving approach',
      achievements: [
        'Taught in Top NEET institutes',
        'Author of NEET Chemistry Guide',
        'Mentored AIR rank holders',
      ],
    ),
    DoctorModel(
      name: 'C - Doctor Profile 3',
      subject: 'Physics',
      profileImage: 'assets/testimonials.png',
      qualification: 'M.Sc (Physics), NET-JRF',
      experience: '6+ years of teaching Physics',
      specialization: 'Mechanics & Electrodynamics',
      teachingStyle: 'Visualization & concept-building techniques',
      achievements: [
        '3000+ students mentored',
        '100+ NEET Physics toppers',
        'Guest Faculty at NEET Workshops',
      ],
    ),
  ];

  List<DoctorModel> get doctors => _doctors;
}
