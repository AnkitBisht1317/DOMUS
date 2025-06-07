import 'package:domus/features/authentication/presentation/screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:domus/features/home/presentation/screens/home_screen.dart';
import 'package:domus/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:domus/features/home/domain/repositories/home_repository.dart';
import 'package:domus/features/home/data/repositories/home_repository_impl.dart';
import 'package:domus/features/authentication/presentation/screens/personal_details.dart';
import 'package:domus/features/home/presentation/viewmodels/home_drawer_viewmodel.dart';
import 'package:domus/features/home/presentation/viewmodels/lectures_view_model.dart';
import 'package:domus/features/authentication/data/repositories/user_repository_impl.dart';
import 'package:domus/features/authentication/domain/repositories/user_repository.dart';
import 'package:domus/features/authentication/domain/view model/home_auth_model.dart';
import 'package:domus/features/authentication/domain/view model/personal_auth_model.dart';
import 'features/home/presentation/viewmodels/cart_view_model.dart';
import 'features/home/presentation/viewmodels/payment_viewmodel.dart';
import 'firebase_options.dart';
import 'package:domus/features/home/presentation/viewmodels/doctor_writings_view_model.dart';
import 'package:domus/features/home/presentation/viewmodels/job_portal_view_model.dart';
import 'config/routes/routes.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkUserDataExists(String uid) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user?.phoneNumber == null) return false;

      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.phoneNumber)
          .collection('personalDetails')
          .doc('current')
          .get();

      return docSnapshot.exists && docSnapshot.data() != null;
    } catch (e) {
      print('Error checking user data: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
        Provider<HomeRepository>(
          create: (_) => HomeRepositoryImpl(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(context.read<HomeRepository>()),
        ),
        ChangeNotifierProvider(
          create: (_) => LecturesViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => DoctorWritingsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => JobPortalViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => HomeDrawerViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => PaymentViewModel()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        theme: ThemeData(
          primaryColor: const Color(0xFF0A1832),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            /*if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading screen while checking auth state
              return const Scaffold(
                body: Center(
                  child: SpinKitPouringHourGlassRefined(
                    color: Color(0xFF022150),
                    size: 50.0,
                  ),
                ),
              );
            }*/

            if (snapshot.hasData && snapshot.data != null) {
              // Check if user data exists in Firestore
              return FutureBuilder<bool>(
                future: _checkUserDataExists(snapshot.data!.uid),
                builder: (context, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(
                        child: SpinKitPouringHourGlassRefined(
                          color: Color(0xFF022150),
                          size: 50.0,
                        ),
                      ),
                    );
                  }

                  // If user data exists, show HomeScreen
                  if (dataSnapshot.data == true) {
                    return const HomeScreen();
                  }

                  // If user is authenticated but no data exists, show PersonalDetails
                  return MultiProvider(
                    providers: [
                      Provider<UserRepository>(
                        create: (_) => UserRepositoryImpl(),
                      ),
                      ChangeNotifierProvider<PersonalAuthModel>(
                        create: (context) => PersonalAuthModel(
                          userRepository: context.read<UserRepository>(),
                        )..phoneController.text = snapshot.data!.phoneNumber ?? '',
                      ),
                    ],
                    child: const PersonalDetails(),
                  );
                },
              );
            }

            // User is not logged in, show authentication page
            return HomePage();
          },
        ),
      ),
    );
  }
}

// Add this at the top level (keep this line)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


