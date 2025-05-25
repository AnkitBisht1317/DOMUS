import 'package:domus/features/authentication/domain/view%20model/select_auth_model.dart';
import 'package:domus/features/authentication/presentation/screens/professional_details.dart';
import 'package:domus/features/authentication/presentation/screens/students_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/view model/student_auth_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/repositories/user_repository_impl.dart';

class WelcomeScreen extends StatelessWidget {
  final String fullName;
  final String gender;

  const WelcomeScreen({
    super.key,
    required this.fullName,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          _buildHeader(height, width),
          Padding(
            padding: EdgeInsets.only(top: height * 0.3),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Stack(
                children: [
                  // Doctor Image
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Image.asset(
                      gender == 'Female' 
                          ? 'assets/girl_doctor.png'
                          : 'assets/boy_doctor.png',
                      height: height * 0.4,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Welcome Text with Squash Background
                  Positioned(
                    top: height * 0.05,
                    right: 0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/squash.png',
                          width: width * 0.65,
                          fit: BoxFit.contain,
                        ),
                        // Text overlay
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.06,
                            vertical: height * 0.03,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello!',
                                style: TextStyle(
                                  fontSize: width * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Welcome',
                                style: TextStyle(
                                  fontSize: width * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                fullName,
                                style: TextStyle(
                                  fontSize: width * 0.06,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double height, double width) {
    return Container(
      height: height * 0.35,
      width: width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6CA8CB), Color(0xFF022150), Color(0xFF022150)],
          begin: Alignment.bottomLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.1, bottom: height * 0.1),
          child: Image.asset(
            'assets/logo.png',
            alignment: Alignment.center,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
