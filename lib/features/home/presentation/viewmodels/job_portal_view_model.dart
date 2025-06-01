import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../config/routes/routes.dart';
import '../../domain/models/job_portal.dart';

class JobPortalViewModel extends ChangeNotifier {
  JobPortal? _jobPortal;
  
  JobPortal? get jobPortal => _jobPortal;

  JobPortalViewModel() {
    _initializeJobPortal();
  }

  void _initializeJobPortal() {
    _jobPortal = JobPortal(
      title: "Job Portal",
      iconPath: "assets/books.png",
      carouselImages: [
        'assets/home_page_banner.png',
        'assets/banner_varient_second.png',
        'assets/banner_varient_third.png',
        'assets/banner_varient_fourth.png',
        'assets/banner_varient_fifth.png',
        'assets/banner_varient_sixth.png',
      ],
    );
    notifyListeners();
  }

  void navigateToJobPortal(BuildContext context) {
    AppRoutes.navigateToJobPortal(context);
  }
} 