import 'package:carousel_slider/carousel_slider.dart';
import 'package:domus/features/home/domain/services/question_sequence_service.dart';
import 'package:domus/features/home/presentation/viewmodels/aim_academy_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/home_repository_impl.dart';
import '../../data/repositories/question_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/repositories/question_repository.dart';
import '../viewmodels/about_view_model.dart';
import '../viewmodels/aim_team_view_model.dart';
import '../viewmodels/bookmark_viewmodel.dart';
import '../viewmodels/cart_view_model.dart';
import '../viewmodels/category_tabs_view_model.dart';
import '../viewmodels/community_view_model.dart';
import '../viewmodels/course_carousel_view_model.dart';
import '../viewmodels/home_drawer_viewmodel.dart';
import '../viewmodels/home_view_model.dart';
import '../viewmodels/lectures_view_model.dart';
import '../viewmodels/profile_view_model.dart';
import '../viewmodels/question_view_model.dart';
import '../viewmodels/quick_fact_viewmodel.dart';
import '../viewmodels/test_series_view_model.dart';
import '../viewmodels/testimonials_drawer_view_model.dart';
import '../viewmodels/testimonials_view_model.dart';
import '../widgets/category_tabs.dart';
import '../widgets/course_carousel.dart';
import '../widgets/doctor_writings_section.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_drawer.dart';
import '../widgets/job_portal_section.dart';
import '../widgets/my_lectures_section.dart';
import '../widgets/question_of_day.dart';
import '../widgets/test_series_section.dart';
import '../widgets/testimonials_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  void initState() {
    super.initState();
    _configureSystemUI();
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
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
        Provider<HomeRepository>(
          create: (_) => HomeRepositoryImpl(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(context.read<HomeRepository>()),
        ),
        ChangeNotifierProvider(create: (_) => LecturesViewModel()),
        ChangeNotifierProvider(create: (_) => TestimonialsViewModel()),
        ChangeNotifierProvider(create: (_) => CourseCarouselViewModel()),
        // Replace it with:
        Provider<QuestionRepository>(
          create: (_) => QuestionRepositoryImpl(
            sequenceService: QuestionSequenceService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => QuestionViewModel(context.read<QuestionRepository>()),
        ),
        ChangeNotifierProvider(create: (_) => TestSeriesViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryTabsViewModel()),
        ChangeNotifierProvider(
            create: (_) =>
                HomeDrawerViewModel()), // No need to pass navigatorKey here
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => QuickFactViewModel()),

        ChangeNotifierProvider(create: (_) => BookmarkViewModel()),
        ChangeNotifierProvider(create: (_) => CommunityViewModel()),
        ChangeNotifierProvider(create: (_) => AboutViewModel()),
        ChangeNotifierProvider(create: (_) => AimAcademyViewModel()),
        ChangeNotifierProvider(create: (_) => TestimonialsDrawerViewModel()),
        ChangeNotifierProvider(create: (_) => AimTeamViewModel()),
      ],
      child: Builder(builder: (context) {
        // Connect the view models
        final courseCarouselViewModel =
            Provider.of<CourseCarouselViewModel>(context, listen: false);
        final cartViewModel =
            Provider.of<CartViewModel>(context, listen: false);
        courseCarouselViewModel.setCartViewModel(cartViewModel);

        return AdvancedDrawer(
          backdrop: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF022150), Color(0xFF1B3B6F)],
              ),
            ),
          ),
          controller: _advancedDrawerController,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          animateChildDecoration: true,
          rtlOpening: false,
          disabledGestures: false,
          childDecoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          drawer: HomeDrawer(controller: _advancedDrawerController),
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
                  Column(
                    children: [
                      // Fixed app bar at the top
                      SafeArea(
                        child: HomeAppBar(
                          onMenuTap: _handleMenuButtonPressed,
                        ),
                      ),
                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
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
                                    SizedBox(height: 16),
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
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeroBanner() {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.banners.isEmpty) return const SizedBox.shrink();

        return CarouselSlider(
          items: viewModel.banners.map((banner) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(banner.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 120,
            viewportFraction: 0.92,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.15,
            scrollDirection: Axis.horizontal,
          ),
        );
      },
    );
  }
}
