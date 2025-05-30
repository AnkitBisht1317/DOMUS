import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_view_model.dart';
import '../viewmodels/lectures_view_model.dart';
import '../viewmodels/testimonials_view_model.dart';
import '../viewmodels/course_carousel_view_model.dart';
import '../viewmodels/question_view_model.dart';
import '../viewmodels/test_series_view_model.dart';
import '../viewmodels/category_tabs_view_model.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/category_tabs.dart';
import '../widgets/course_carousel.dart';
import '../widgets/question_of_day.dart';
import '../widgets/test_series_section.dart';
import '../widgets/doctor_writings_section.dart';
import '../widgets/job_portal_section.dart';
import '../widgets/testimonials_section.dart';
import '../widgets/my_lectures_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _configureSystemUI();
  }

  void _configureSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => LecturesViewModel()),
        ChangeNotifierProvider(create: (_) => TestimonialsViewModel()),
        ChangeNotifierProvider(create: (_) => CourseCarouselViewModel()),
        ChangeNotifierProvider(create: (_) => QuestionViewModel()),
        ChangeNotifierProvider(create: (_) => TestSeriesViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryTabsViewModel()),
      ],
      child: Theme(
        data: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.light,
            ),
          ),
        ),
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F8F8),
          extendBodyBehindAppBar: true,
          extendBody: true,
          body: Stack(
            children: [
              // Background gradient
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: height * 0.35,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF022150),
                        Color(0xFF022150),
                        Color(0xFF022150),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // Main content
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const HomeAppBar(),
                      _buildHeroBanner(),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SizedBox(height: 16),
                            Center(
                              child: Text(
                                'Domus Homoeopathica',
                                style: TextStyle(
                                  color: Color(0xFFAAAAAA),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            CategoryTabs(),
                            QuestionOfDaySection(),
                            TestSeriesSection(),
                            CourseCarousel(),
                            MyLecturesSection(),
                            DoctorWritingsSection(),
                            JobPortalSection(),
                            TestimonialsSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.banners.isEmpty) return const SizedBox.shrink();
        
        final banner = viewModel.banners.first;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(banner.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
