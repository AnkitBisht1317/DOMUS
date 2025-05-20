import 'package:domus/features/authentication/domain/view%20model/select_auth_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectOption extends StatelessWidget {
  const SelectOption({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SelectAuthModel>(context);
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${viewModel.userType == 'student' ? "Medical Student" : "Medical Professional"} selected',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // TODO: Navigate to the next screen
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
      builder:
          (context, viewModel, _) => Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: width * 0.08,
                  backgroundColor: const Color(0xFF022150),
                  child: Icon(
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
