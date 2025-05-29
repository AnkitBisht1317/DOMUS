import 'package:domus/features/authentication/presentation/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfessionalDetailsPG extends StatefulWidget {
  final String gender;
  final String designation;
  final String fullName;
  final String mobileNumber;

  const ProfessionalDetailsPG({
    super.key,
    required this.gender,
    required this.designation,
    required this.fullName,
    required this.mobileNumber,
  });

  @override
  State<ProfessionalDetailsPG> createState() => _ProfessionalDetailsPGState();
}

class _ProfessionalDetailsPGState extends State<ProfessionalDetailsPG> {
  String? selectedYear;
  String? selectedState;
  String? selectedCollege;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _updatePGDetails() async {
    try {
      // Reference to the professional details document
      final docRef = _firestore
          .collection('users')
          .doc(widget.mobileNumber)
          .collection('professional_details')
          .doc('current');

      // Update PG fields and set isVerified to true since all details are now complete
      await docRef.set({
        'pg_year': selectedYear,
        'pg_state': selectedState,
        'pg_clg_name': selectedCollege,
        'isVerified': true,  // Set to true as all details are now complete
      }, SetOptions(merge: true));

      // Navigate to welcome screen after successful update
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(
              fullName: widget.fullName,
              gender: widget.gender,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating PG details: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.06,
                        vertical: height * 0.015,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeaderRow(width, height),
                          SizedBox(height: height * 0.02),
                          Text(
                            'Fill Your Academic Information',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: width * 0.04,
                            ),
                          ),
                          SizedBox(height: height * 0.03),
                          Text(
                            'Professional Details',
                            style: TextStyle(
                              color: const Color(0xFF022150),
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  'Academic Details (PG) (Optional/Skip)',
                                  style: TextStyle(
                                    color: const Color(0xFF022150),
                                    fontSize: width * 0.04,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: SizedBox(
                                  height: 36,
                                  child: TextButton(
                                    onPressed: () {
                                      // Skip button functionality will be added later
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: const BorderSide(
                                          color: Color(0xFF022150),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'SKIP',
                                      style: TextStyle(
                                        color: Color(0xFF022150),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.03),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: selectedYear,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'PG Year of Completion',
                              ),
                              items: ['2020', '2021', '2022', '2023']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedYear = newValue;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: selectedState,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'PG State',
                              ),
                              items: ['State 1', 'State 2', 'State 3']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedState = newValue;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: selectedCollege,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'PG College Name',
                              ),
                              items: ['College 1', 'College 2', 'College 3']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCollege = newValue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                        bottom: height * 0.02,
                      ),
                      child: ElevatedButton(
                        onPressed: (selectedYear != null && selectedState != null && selectedCollege != null)
                            ? _updatePGDetails
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (selectedYear != null && selectedState != null && selectedCollege != null)
                              ? const Color(0xFF022150)
                              : const Color(0xFF9BA4B5),
                          minimumSize: Size(double.infinity, height * 0.06),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'NEXT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

  Widget _buildHeaderRow(double width, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: width * 0.08,
                backgroundColor: const Color(0xFF022150),
                child: widget.gender == 'Male'
                    ? ClipOval(
                        child: Image.asset(
                          'assets/male.png',
                          width: width * 0.16,
                          height: width * 0.16,
                          fit: BoxFit.cover,
                        ),
                      )
                    : widget.gender == 'Female'
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Details',
                    style: TextStyle(
                      color: const Color(0xFF022150),
                      fontSize: width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  Text(
                    'Fill Your Academic Information',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: width * 0.04,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: height * 0.03),
        Text(
          'Professional Details',
          style: TextStyle(
            color: const Color(0xFF022150),
            fontSize: width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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