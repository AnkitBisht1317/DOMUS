import 'package:domus/features/authentication/domain/view%20model/select_auth_model.dart';
import 'package:domus/features/authentication/presentation/screens/professional_details_designation.dart';
import 'package:domus/features/authentication/presentation/screens/students_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/view model/student_auth_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/repositories/user_repository_impl.dart';

class SelectOption extends StatelessWidget {
  final String gender;
  final String phoneNumber;
  final String fullname;
  
  const SelectOption({
    super.key,
    required this.gender,
    required this.phoneNumber,
    required this.fullname
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SelectAuthModel>(context)..setGender(gender);
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
                    SizedBox(height: height * 0.09),

                    // Option Selector Row
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildUserTypeButton(
                          context,
                          title: 'Medical Student',
                          isSelected: viewModel.userType == 'student',
                          onTap: () => viewModel.setUserType('student'),
                        ),
                        SizedBox(
                          height: height * 0.07,
                        ), // Gap between the two boxes
                        _buildUserTypeButton(
                          context,
                          title: 'Medical Professional',
                          isSelected: viewModel.userType == 'professional',
                          onTap: () => viewModel.setUserType('professional'),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.06),

                    // Next Button
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
                        onPressed: () {
                          if (viewModel.userType == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select an option first."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            // Navigate based on user type
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => viewModel.userType == 'student'
                                    ? MultiProvider(
                                        providers: [
                                          Provider<UserRepository>(
                                            create: (_) => UserRepositoryImpl(),
                                          ),
                                          ChangeNotifierProxyProvider<UserRepository, StudentAuthModel>(
                                            create: (context) => StudentAuthModel(
                                              userRepository: context.read<UserRepository>(),
                                            ),
                                            update: (context, repository, previous) =>
                                                previous ?? StudentAuthModel(userRepository: repository),
                                          ),
                                        ],
                                        child: StudentDetails(
                                          gender: gender,
                                          phoneNumber: phoneNumber,
                                        ),
                                      )
                                    : ProfessionalDetails(gender: gender,fullName: fullname, mobileNumber: phoneNumber),
                              ),
                            );
                          }
                        },
                        child: Text(
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
    return Consumer<SelectAuthModel>(
      builder: (context, viewModel, _) => Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: width * 0.08,
              backgroundColor: const Color(0xFF022150),
              child: viewModel.gender == 'Male'
                  ? ClipOval(
                      child: Image.asset(
                        'assets/male.png',
                        width: width * 0.16,
                        height: width * 0.16,
                        fit: BoxFit.cover,
                      ),
                    )
                  : viewModel.gender == 'Female'
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
              'Personal Details',
              style: TextStyle(
                color: const Color(0xFF022150),
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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

  Widget _buildUserTypeButton(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: width * 0.035),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF022150) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF022150) : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: width * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
