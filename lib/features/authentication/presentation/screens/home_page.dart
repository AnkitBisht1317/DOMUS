import 'package:domus/features/authentication/presentation/screens/personal_details.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../domain/view model/home_auth_model.dart';
import '../../domain/view model/personal_auth_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/repositories/user_repository_impl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Consumer<AuthViewModel>(
        builder: (context, viewModel, _) {
          return Stack(
            children: [
              Container(
                height: height * 0.35,
                width: width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF6CA8CB),
                      Color(0xFF022150),
                      Color(0xFF022150),
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.15,
                    left: width * 0.0,
                    bottom: width * 0.15,
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 0.3),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  height: height * 0.9,
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
                        Padding(
                          padding: const EdgeInsets.only(right: 30, top: 5),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                if (viewModel.phoneNumber.isNotEmpty) {
                                  viewModel.sendOtp(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please enter a phone number",
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Get OTP',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                ),
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
                              onPressed: () async {
                                if (!viewModel.validateCheckbox()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please accept terms and conditions",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                bool result = await viewModel.verifyOtp(
                                  context,
                                );
                                if (result) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MultiProvider(
                                        providers: [
                                          Provider<UserRepository>(
                                            create: (_) => UserRepositoryImpl(),
                                          ),
                                          ChangeNotifierProvider<PersonalAuthModel>(
                                            create: (context) => PersonalAuthModel(
                                              userRepository: context.read<UserRepository>(),
                                            )..phoneController.text = viewModel.phoneNumber,
                                          ),
                                        ],
                                        child: const PersonalDetails(),
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("OTP verification failed"),
                                    ),
                                  );
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
                        const SizedBox(height: 20),
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
