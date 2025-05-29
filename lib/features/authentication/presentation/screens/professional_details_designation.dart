import 'package:domus/features/authentication/domain/view%20model/select_auth_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'professional_details_ug.dart';

class ProfessionalDetails extends StatefulWidget {
  final String gender;
  final String fullName;
  final String mobileNumber;

  const ProfessionalDetails({
    super.key,
    required this.gender,
    required this.fullName,
    required this.mobileNumber,
  });

  @override
  State<ProfessionalDetails> createState() => _ProfessionalDetailsState();
}

class _ProfessionalDetailsState extends State<ProfessionalDetails> {
  String? selectedDesignation;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _updateProfessionalDetails() async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(widget.mobileNumber)
          .collection('professional_details')
          .doc('current');

      await docRef.set({
        'designation': selectedDesignation,
        'isVerified': false,
        'ug_state': null,
        'ug_clg_name': null,
        'pg_year': null,
        'pg_state': null,
        'pg_clg_name': null,
      }, SetOptions(merge: true));

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfessionalDetailsUG(
              gender: widget.gender,
              designation: selectedDesignation!,
              fullName: widget.fullName,
              mobileNumber: widget.mobileNumber,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating details: $e'),
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
                          _buildHeaderRow(width),
                          SizedBox(height: height * 0.04),
                          Text(
                            'Fill Your Academic Information',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: width * 0.04,
                            ),
                          ),
                          SizedBox(height: height * 0.04),
                          Text(
                            'Professional Details',
                            style: TextStyle(
                              color: const Color(0xFF022150),
                              fontSize: width * 0.055,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: height * 0.03),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: selectedDesignation,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Select Designation',
                              ),
                              items: ['Doctor', 'Specialist', 'Consultant']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedDesignation = newValue;
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
                        onPressed: selectedDesignation != null
                            ? _updateProfessionalDetails
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedDesignation != null
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

  Widget _buildHeaderRow(double width) {
    return Center(
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
