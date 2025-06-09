import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/view model/student_auth_model.dart';
import '../screens/welcome_screen.dart';

class StudentDetails extends StatelessWidget {
  final String gender;
  final String phoneNumber;

  const StudentDetails({
    super.key,
    required this.gender,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final viewModel = Provider.of<StudentAuthModel>(context);

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
                    SizedBox(height: height * 0.015),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Academic Details',
                            style: TextStyle(
                              color: const Color(0xFF022150),
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Your Batch*',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        'First Year BHMS',
                        'Second Year BHMS',
                        'Third Year BHMS',
                        'Final Year BHMS',
                        'Intern',
                        'First Year PG Scholar',
                        'Second Year PG Scholar',
                        'Final Year PG Scholar',
                      ].map((batch) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.grey[400],
                            radioTheme: RadioThemeData(
                              fillColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return const Color(0xFF022150);
                                  }
                                  return Colors.grey[400]!;
                                },
                              ),
                            ),
                          ),
                          child: RadioListTile<String>(
                            title: Text(
                              batch,
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colors.grey[800],
                              ),
                            ),
                            value: batch,
                            groupValue: viewModel.selectedBatch,
                            onChanged: viewModel.setBatch,
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            visualDensity: const VisualDensity(
                              horizontal: -4,
                              vertical: -4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: height * 0.02),
                    DropdownButtonFormField<String>(
                      value: viewModel.selectedState,
                      isExpanded: true,
                      decoration: InputDecoration(
                        hintText: 'UG College State',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                      items: [
                        'Andhra Pradesh',
                        'Karnataka',
                        'Kerala',
                        'Maharashtra',
                        'Tamil Nadu',
                        'Telangana',
                      ].map((state) {
                        return DropdownMenuItem(
                          value: state,
                          child: Text(
                            state,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: viewModel.setState,
                    ),
                    SizedBox(height: height * 0.02),
                    DropdownButtonFormField<String>(
                      value: viewModel.selectedCollege,
                      isExpanded: true,
                      decoration: InputDecoration(
                        hintText: 'UG College Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                      items: viewModel.selectedState == 'Maharashtra'
                          ? [
                              'Maharashtra Homoeopathic Medical College',
                              'D.K.M.M. Homoeopathic Medical College',
                            ].map((college) {
                              return DropdownMenuItem(
                                value: college,
                                child: Text(
                                  college,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList()
                          : viewModel.selectedState == 'Karnataka'
                              ? [
                                  'Father Muller Homoeopathic Medical College',
                                  'A.M. Shaikh Homoeopathic Medical College',
                                ].map((college) {
                                  return DropdownMenuItem(
                                    value: college,
                                    child: Text(
                                      college,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList()
                              : [],
                      onChanged: viewModel.setCollege,
                    ),
                    SizedBox(height: height * 0.04),
                    SizedBox(
                      width: double.infinity,
                      height: height * 0.065,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF022150),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: viewModel.isSaving || !viewModel.isFormValid()
                            ? null
                            : () async {
                                if (await viewModel.saveAcademicDetails(phoneNumber)) {
                                  // Get user details to pass to welcome screen
                                  final userRepo = context.read<UserRepository>();
                                  final userDetails = await userRepo.getUserDetails(phoneNumber);
                                  
                                  if (!context.mounted) return;
                                  
                                  // Show success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Academic details saved successfully!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  // Navigate to welcome screen and clear all previous routes
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WelcomeScreen(
                                        fullName: userDetails?.fullName ?? 'Student',
                                        gender: gender,
                                      ),
                                    ),
                                    (route) => false, // This removes all previous routes
                                  );
                                } else if (viewModel.error != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(viewModel.error!),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                        child: viewModel.isSaving
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'NEXT',
                                style: TextStyle(
                                  fontSize: width * 0.045,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
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
                      'assets/male_student.png',
                      width: width * 0.16,
                      height: width * 0.16,
                      fit: BoxFit.cover,
                    ),
                  )
                : gender == 'Female'
                    ? ClipOval(
                        child: Image.asset(
                          'assets/female_student.png',
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
