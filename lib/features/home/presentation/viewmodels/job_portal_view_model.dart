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
    _jobPortal = const JobPortal(
      title: "Job Portal",
      iconPath: "assets/books.png",
      bannerPath: "assets/home_page_banner.png",
      description: "Find the best opportunities in homeopathy",
    );
    notifyListeners();
  }

  void navigateToJobPortal(BuildContext context) {
    AppRoutes.navigateToJobPortal(context);
  }
} 