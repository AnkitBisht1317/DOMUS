import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../view/auth_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Consumer<AuthViewModel>(
        builder: (context, viewModel, child) {
          return Stack(
            children: [
              Container(
                height: height*0.35,
                width: width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF6CA8CB), // Light teal blue first
                      Color(0xFF022150),// Dark navy blue second
                      Color(0xFF022150),// Dark navy blue second
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.15,
                    left: width * 0.0,
                    bottom: width*0.15
                  ),
                  child: Image.asset('assets/logo.png',alignment: Alignment.center,fit: BoxFit.contain,),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 0.3),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  height: height * 0.7,
                  width: width,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        const Center(
                          child: Text(
                            'Get Started Free.',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A2A5C),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Login with Phone number',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                          ),
                          child: IntlPhoneField(
                            decoration: InputDecoration(
                              hintText: 'Enter Mobile Number',
                              counterText: '',
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                            initialCountryCode: 'IN',
                            showDropdownIcon: true,
                            dropdownIconPosition: IconPosition.trailing,
                            onChanged: (phone) {
                              viewModel.setPhoneNumber(phone.completeNumber);
                            },
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 30, top: 5),
                            child: Text(
                              'Get OTP',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Enter OTP',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                            vertical: 10,
                          ),
                          child: PinCodeTextField(
                            appContext: context,
                            length: 6,
                            controller: TextEditingController(
                              text: viewModel.otp,
                            ),
                            obscureText: false,
                            animationType: AnimationType.none,
                            keyboardType: TextInputType.number,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(6),
                              fieldHeight: 50,
                              fieldWidth: 50,
                              activeFillColor: Colors.white,
                              selectedColor: Colors.grey,
                              inactiveColor: Colors.grey,
                            ),
                            onChanged: (value) {
                              viewModel.setOtp(value);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: viewModel.isChecked,
                                activeColor: Colors.green,
                                onChanged: (value) {
                                  viewModel.toggleCheckbox(value!);
                                },
                              ),
                              const Flexible(
                                child: Text(
                                  "I accept the term and condition",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.1,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0A2A5C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                // Handle verify logic
                                if (viewModel.validateForm()) {
                                  print("Verified: ${viewModel.otp}");
                                } else {
                                  print("Please complete all fields");
                                }
                              },
                              child: const Text(
                                'VERIFY',
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
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
          );
        },
      ),
    );
  }
}
