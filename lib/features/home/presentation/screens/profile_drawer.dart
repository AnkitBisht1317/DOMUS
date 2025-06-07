import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/profile_view_model.dart';

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

    return Scaffold(
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
                        onPressed: () => Navigator.pop(context),
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
                        "Student Name",
                        viewModel.nameController,
                        true,
                        width,
                        editableFieldLabel,
                        (val) => setState(() => editableFieldLabel = val)),
                    profileField(
                        "Mobile Number",
                        viewModel.mobileController,
                        false,
                        width,
                        editableFieldLabel,
                        (val) => setState(() => editableFieldLabel = val)),
                    profileField(
                        "Email",
                        viewModel.emailController,
                        false,
                        width,
                        editableFieldLabel,
                        (val) => setState(() => editableFieldLabel = val)),
                    profileField(
                        "Year/Batch",
                        viewModel.yearController,
                        true,
                        width,
                        editableFieldLabel,
                        (val) => setState(() => editableFieldLabel = val)),
                    profileField(
                        "U.G College",
                        viewModel.ugCollegeController,
                        false,
                        width,
                        editableFieldLabel,
                        (val) => setState(() => editableFieldLabel = val)),
                    profileField(
                        "P.G College",
                        viewModel.pgCollegeController,
                        false,
                        width,
                        editableFieldLabel,
                        (val) => setState(() => editableFieldLabel = val)),
                    SizedBox(height: padding * 1.5),
                    sectionTitle("Other Details", width),
                    profileField(
                        "Date of Birth",
                        viewModel.dobController,
                        false,
                        width,
                        editableFieldLabel,
                        (val) => setState(() => editableFieldLabel = val)),
                    profileField(
                        "U.G College State",
                        viewModel.ugStateController,
                        false,
                        width,
                        editableFieldLabel,
                        (val) => setState(() => editableFieldLabel = val)),
                    profileField(
                        "P.G College state",
                        viewModel.pgStateController,
                        false,
                        width,
                        editableFieldLabel,
                        (val) => setState(() => editableFieldLabel = val)),
                    profileField(
                        "Domicile State",
                        viewModel.domicileStateController,
                        false,
                        width,
                        editableFieldLabel,
                        (val) => setState(() => editableFieldLabel = val)),
                    profileField(
                        "Gender",
                        viewModel.genderController,
                        false,
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
                        onTap: viewModel.deleteAccount,
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
        readOnly: !isEditing && isEditableField,
        focusNode: isEditableField ? focusNode : null,
        style: TextStyle(fontSize: screenWidth * 0.038),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black54),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: isEditableField
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
    print('Saved $label: $newValue');
  }
}
