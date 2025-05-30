import 'package:flutter/foundation.dart';
import '../../domain/models/testimonial.dart';

class TestimonialsViewModel extends ChangeNotifier {
  Testimonial? _testimonial;
  
  Testimonial? get testimonial => _testimonial;

  TestimonialsViewModel() {
    _initializeTestimonial();
  }

  void _initializeTestimonial() {
    _testimonial = const Testimonial(
      title: "Congratulations",
      doctorName: "Dr. Abhishek Shukla",
      certification: "VISHAL MEGAMART certified",
      location: "Madhya Pradesh",
      description: "The language used in this book is simple and easy to grasp, making it very helpful for students.\n\nTo all future aspirants: \"Success is not just about hard work; it's about working smart with the right resources.\"",
      imagePath: "assets/books.png",
      lightTrianglePath: "assets/traingle_bg_faded.png",
      darkTrianglePath: "assets/triangle_bg_darker.png",
    );
    notifyListeners();
  }
} 