import 'package:domus/features/authentication/domain/view%20model/personal_auth_model.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class PersonalDetails extends StatelessWidget {
  const PersonalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PersonalAuthModel>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // ********************* avtar or personal details ka or white blue container ka code last me hai ***************************
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
                child: Form(
                  key: viewModel.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderRow(width),
                      SizedBox(height: height * 0.02),
                      _buildTextField(
                        'Enter Your Full Name',
                        controller: viewModel.fullNameController,
                      ),
                      SizedBox(height: height * 0.007), // in box ka size reduced kr dena
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Change Mobile no.',
                            style: TextStyle(fontSize: width * 0.035),
                          ),
                        ),
                      ),
                      IntlPhoneField(
                        initialCountryCode: 'IN',
                        decoration: InputDecoration(
                          hintText: 'Enter Mobile Number',
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged:
                            (phone) =>
                                viewModel.phoneController.text =
                                    phone.completeNumber,
                      ),
                      SizedBox(height: height * 0.012),
                      _buildTextField(
                        'Email Address',
                        controller: viewModel.emailController,
                      ),
                      SizedBox(height: height * 0.012),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: viewModel.selectedGender,
                              onChanged: (val) => viewModel.setGender(val!),
                              items:
                                  ['Male', 'Female', 'Other']
                                      .map(
                                        (g) => DropdownMenuItem(
                                          value: g,
                                          child: Text(g),
                                        ),
                                      )
                                      .toList(),
                              decoration: _inputDecoration(),
                            ),
                          ),
                          SizedBox(width: width * 0.03),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              controller: viewModel.dobController,
                              decoration: _inputDecoration(hint: 'DOB'),
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2000),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  viewModel.setDOB(
                                    "${picked.day}/${picked.month}/${picked.year}",
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.012),
                      DropdownButtonFormField<String>(
                        value: viewModel.selectedCountry, // select contry ka dropdown mene manully bnaya hai ye agr kise or method se hoga thik hai wrna rhn dena
                        onChanged: (val) => viewModel.setCountry(val!),
                        decoration: _inputDecoration(
                          hint: 'Select Your Country',
                        ),
                        items:
                            [
                                  'India',
                                  'USA',
                                  'UK',
                                  'Canada',
                                  'Germany',
                                  'Australia',
                                  'France',
                                ]
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ),
                                )
                                .toList(),
                      ),
                      SizedBox(height: height * 0.012),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Domicile State',
                              controller: viewModel.domicileStateController,
                            ),
                          ),
                          SizedBox(width: width * 0.03),
                          Expanded(
                            child: _buildTextField(
                              'District',
                              controller: viewModel.districtController,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
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
                            if (viewModel.validateAndSave()) {
                              final data = viewModel.collectUserDetails();
                              // Pass to next screen or use
                            }
                          },
                          child: Text(
                            'NEXT',
                            style: TextStyle(fontSize: width * 0.045),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(hint: hint),
      validator: (value) {
        if (hint.contains("Email")) {
          return !RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value ?? '')
              ? 'Enter a valid email'
              : null;
        }
        return (value == null || value.isEmpty)
            ? 'This field is required'
            : null;
      },
    );
  }

  Widget _buildHeaderRow(double width) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ******************** avtar ka code ye hai ************************
          CircleAvatar(
            radius: width * 0.08,
            backgroundColor: const Color(0xFF022150),
            // ************************ ye change hoga agr male huaa to male ki photo wrna female *****************************
            child: Icon(Icons.person, size: width * 0.1, color: Colors.white),
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
          padding: EdgeInsets.only(top: height * 0.1),
          child: Image.asset(
            'assets/logo.png',
            alignment: Alignment.center,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
