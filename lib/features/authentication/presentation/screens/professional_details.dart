import 'package:domus/features/authentication/domain/view%20model/select_auth_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfessionalDetails extends StatelessWidget {
  final String gender;

  const ProfessionalDetails({
    super.key,
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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06,
                  vertical: height * 0.015,
                ),
                child: Column(
                  children: [
                    _buildHeaderRow(width),
                    SizedBox(height: height * 0.04),
                    // Add your professional-specific form fields here
                    Text('Professional Details Form - Coming Soon'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(double width) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: width * 0.08,
            backgroundColor: const Color(0xFF022150),
            child: gender == 'Male'
                ? ClipOval(
                    child: Image.asset(
                      'assets/male.png',
                      width: width * 0.16,
                      height: width * 0.16,
                      fit: BoxFit.cover,
                    ),
                  )
                : gender == 'Female'
                    ? ClipOval(
                        child: Image.asset(
                          'assets/female.png',
                          width: width * 0.16,
                          height: width * 0.16,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: width * 0.1,
                        color: Colors.white,
                      ),
          ),
          SizedBox(width: width * 0.04),
          Text(
            'Professional Details',
            style: TextStyle(
              color: const Color(0xFF022150),
              fontSize: width * 0.06,
              fontWeight: FontWeight.bold,
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
