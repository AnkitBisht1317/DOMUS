import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/profile_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  String? editableFieldLabel;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final padding = width * 0.04;

    if (viewModel.isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF022150),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (viewModel.error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF022150),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 48),
              SizedBox(height: 16),
              Text(
                'Error loading profile',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              TextButton(
                onPressed: () => viewModel.loadUserData(),
                child: Text('Retry', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        // Save any pending changes when navigating back
        if (editableFieldLabel != null) {
          saveField(editableFieldLabel!, getControllerForLabel(editableFieldLabel!).text);
          setState(() => editableFieldLabel = null);
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF022150),
        body: Column(
          children: [
            Container(
              height: height * 0.28,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: height * 0.07,
                    child: Opacity(
                      opacity: 0.15,
                      child: Image.asset(
                        'assets/logo.png',
                        width: width * 0.9,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.11,
                    child: GestureDetector(
                      onTap: viewModel.pickImage,
                      child: CircleAvatar(
                        radius: width * 0.12,
                        backgroundImage: viewModel.profileImage != null
                            ? FileImage(viewModel.profileImage!)
                            : const AssetImage('assets/male.png')
                                as ImageProvider,
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.22,
                    child: Text(
                      'Change Profile Picture',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.035,
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.035,
                    left: padding,
                    right: padding,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.white),
                          onPressed: () {
                            // Save any pending changes when navigating back
                            if (editableFieldLabel != null) {
                              saveField(editableFieldLabel!, getControllerForLabel(editableFieldLabel!).text);
                              setState(() => editableFieldLabel = null);
                            }
                            Navigator.pop(context);
                          },
                          iconSize: width * 0.045,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionTitle("Medicos Info", width),
                      profileField(
                          viewModel.hasProfessionalDetails ? "Professor Name" : "Student Name",
                          viewModel.nameController,
                          true,
                          width,
                          editableFieldLabel,
                          (val) => setState(() => editableFieldLabel = val)),
                      profileField(
                          "Mobile Number",
                          viewModel.mobileController,
                          false, // Mobile number should not be editable
                          width,
                          null, // Never allow editing mobile number
                          (val) => {}), // Empty callback for mobile number
                      profileField(
                          "Email",
                          viewModel.emailController,
                          true,
                          width,
                          editableFieldLabel,
                          (val) => setState(() => editableFieldLabel = val)),
                      if (!viewModel.hasProfessionalDetails) // Show only for students
                        profileField(
                            "Year/Batch",
                            viewModel.yearController,
                            true,
                            width,
                            editableFieldLabel,
                            (val) => setState(() => editableFieldLabel = val)),
                      if (!viewModel.hasProfessionalDetails) // Show only for students
                        profileField(
                            "U.G College",
                            viewModel.ugCollegeController,
                            true,
                            width,
                            editableFieldLabel,
                            (val) => setState(() => editableFieldLabel = val)),
                      if (viewModel.hasProfessionalDetails) // Show only for professors
                        profileField(
                            "Designation",
                            viewModel.designationController,
                            true,
                            width,
                            editableFieldLabel,
                            (val) => setState(() => editableFieldLabel = val)),
                      profileField(
                          "P.G College",
                          viewModel.pgCollegeController,
                          true,
                          width,
                          editableFieldLabel,
                          (val) => setState(() => editableFieldLabel = val)),
                      SizedBox(height: padding * 1.5),
                      sectionTitle("Other Details", width),
                      profileField(
                          "Date of Birth",
                          viewModel.dobController,
                          true,
                          width,
                          editableFieldLabel,
                          (val) => setState(() => editableFieldLabel = val)),
                      if (!viewModel.hasProfessionalDetails) // Show only for students
                        profileField(
                            "U.G College State",
                            viewModel.ugStateController,
                            true,
                            width,
                            editableFieldLabel,
                            (val) => setState(() => editableFieldLabel = val)),
                      profileField(
                          "P.G College state",
                          viewModel.pgStateController,
                          true,
                          width,
                          editableFieldLabel,
                          (val) => setState(() => editableFieldLabel = val)),
                      profileField(
                          "Domicile State",
                          viewModel.domicileStateController,
                          true,
                          width,
                          editableFieldLabel,
                          (val) => setState(() => editableFieldLabel = val)),
                      profileField(
                          "Gender",
                          viewModel.genderController,
                          true,
                          width,
                          editableFieldLabel,
                          (val) => setState(() => editableFieldLabel = val)),
                      SizedBox(height: padding * 1.5),
                      sectionTitle("Delete Account", width),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red.shade400),
                        ),
                        child: InkWell(
                          onTap: () async {
                            // Show confirmation dialog
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Account'),
                                content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            ) ?? false;
                      
                            if (confirmed) {
                              // Show loading indicator
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Center(child: CircularProgressIndicator()),
                              );
                          
                              // Delete account
                              final success = await viewModel.deleteAccount();
                              
                              // Close loading dialog
                              Navigator.pop(context);
                              
                              if (success) {
                                // Make sure user is signed out
                                try {
                                  await FirebaseAuth.instance.signOut();
                                } catch (e) {
                                  debugPrint("Error signing out: $e");
                                  // Continue anyway
                                }
                                
                                // Navigate to login page and clear all routes
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/', // Assuming '/' is the route for the login/welcome page
                                  (route) => false, // This removes all previous routes
                                );
                              } else {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed to delete account data')),
                                );
                              }
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: padding * 0.7,
                              horizontal: padding * 0.7,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline,
                                    color: Colors.red, size: width * 0.07),
                                SizedBox(width: padding * 0.6),
                                Expanded(
                                  child: Text(
                                    "Remove All Data From AIM Homeopathy.",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: width * 0.04),
                                  ),
                                ),
                              ],
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
      ),
    );
  }

  Widget profileField(
    String label,
    TextEditingController controller,
    bool isEditableField,
    double screenWidth,
    String? editableFieldLabel,
    Function(String?) onEditChange,
  ) {
    bool isEditing = (editableFieldLabel == label);
    FocusNode focusNode = FocusNode();

    focusNode.addListener(() {
      if (!focusNode.hasFocus && isEditing) {
        onEditChange(null);
        saveField(label, controller.text);
      }
    });

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
      child: TextField(
        controller: controller,
        readOnly: !isEditing && isEditableField || label == "Mobile Number", // Always make mobile number read-only
        focusNode: isEditableField && label != "Mobile Number" ? focusNode : null, // No focus node for mobile number
        style: TextStyle(fontSize: screenWidth * 0.038),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black54),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: isEditableField && label != "Mobile Number" // No edit icon for mobile number
              ? IconButton(
                  icon: Icon(
                    isEditing ? Icons.check : Icons.edit,
                    size: screenWidth * 0.05,
                  ),
                  onPressed: () {
                    if (isEditing) {
                      focusNode.unfocus();
                      onEditChange(null);
                      saveField(label, controller.text);
                    } else {
                      onEditChange(label);
                      Future.delayed(
                        const Duration(milliseconds: 100),
                        () => FocusScope.of(context).requestFocus(focusNode),
                      );
                    }
                  },
                )
              : Icon(Icons.info_outline, size: screenWidth * 0.05),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: Colors.grey.shade700,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: Colors.grey.shade900,
              width: 1.5,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.03,
            horizontal: screenWidth * 0.04,
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.035),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth * 0.045,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void saveField(String label, String newValue) {
    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    
    // Map UI field labels to database field names
    Map<String, String> fieldMapping = {
      'Student Name': 'fullName',
      'Professor Name': 'fullName',
      'Mobile Number': 'phoneNumber',
      'Email': 'email',
      'Year/Batch': 'batch',
      'U.G College': 'collegeName',
      'P.G College': 'pg_clg_name',
      'Date of Birth': 'dob',
      'U.G College State': 'collegeState',
      'P.G College state': 'pg_state',
      'Domicile State': 'domicileState',
      'Gender': 'gender',
      'Designation': 'designation',
    };
    
    String? fieldName = fieldMapping[label];
    if (fieldName != null) {
      viewModel.updateUserData(fieldName, newValue);
    }
    
    print('Saved $label: $newValue');
  }



  // Helper method to get the controller for a given label
  TextEditingController getControllerForLabel(String label) {
    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    
    switch (label) {
      case 'Student Name':
      case 'Professor Name':
        return viewModel.nameController;
      case 'Mobile Number':
        return viewModel.mobileController;
      case 'Email':
        return viewModel.emailController;
      case 'Year/Batch':
        return viewModel.yearController;
      case 'U.G College':
        return viewModel.ugCollegeController;
      case 'P.G College':
        return viewModel.pgCollegeController;
      case 'Date of Birth':
        return viewModel.dobController;
      case 'U.G College State':
        return viewModel.ugStateController;
      case 'P.G College state':
        return viewModel.pgStateController;
      case 'Domicile State':
        return viewModel.domicileStateController;
      case 'Gender':
        return viewModel.genderController;
      case 'Designation':
        return viewModel.designationController;
      default:
        return TextEditingController();
    }
  }
}
