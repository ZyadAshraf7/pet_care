import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/models/user_model.dart';
import 'package:pet_care/screens/register_screen/phone_verification_screen.dart';

import '../../constants/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _resgisterKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  String verificationID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create an account",
          style: TextStyle(color: AppColors.primaryBlue, fontSize: 24),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primaryBlue),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          height: MediaQuery.of(context).size.height-100,
          child: Center(
            child: Form(
              key: _resgisterKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Name",
                      style: TextStyle(color: AppColors.primaryBlue)),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: name,
                    validator: (value) { // Validate email is valid using RegEx
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: "Mohammed Ali"),
                  ),
                  const SizedBox(height: 8),
                  const Text("Email",
                      style: TextStyle(color: AppColors.primaryBlue)),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: email,
                    validator: (value) {
                      final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'); // Validate email is valid using RegEx
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!emailRegex.hasMatch(value)) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: "example@gmail.com"),
                  ),
                  const SizedBox(height: 8),
                  const Text("Mobile Number",
                      style: TextStyle(color: AppColors.primaryBlue)),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: phoneNumber,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      const phoneMinLength = 11;
                      if (value == null || value.isEmpty) {
                        return 'Phone Number is required';
                      }
                      if (value.length < phoneMinLength) {
                        return 'Phone Number must be at least $phoneMinLength numbers long';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "012xxxxxxxx",
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_resgisterKey.currentState!.validate()) {
                              print("valid");
                              String phoneNumberFormatted = "+2${phoneNumber.text}";
                              print("phone Number !! ${phoneNumberFormatted}");
                              FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: phoneNumberFormatted,
                                timeout: const Duration(seconds: 60),
                                verificationCompleted:
                                    (PhoneAuthCredential credential) async {
                                  print("Verification Completed");
                                },
                                verificationFailed: (FirebaseAuthException e) {
                                  print(e.toString());
                                },
                                codeSent: (String verificationId,
                                    int? resendToken) async {
                                  verificationID = verificationId;
                                  print("code sent function");
                                  UserModel userInfo = UserModel(phoneNumber: phoneNumberFormatted,name: name.text,email: email.text,);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => PhoneVerificationScreen(
                                          user: userInfo,
                                          isRegister: true,
                                          verificationID: verificationID)));
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {
                                  //verificationID = verificationId;
                                },
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.primaryBlue),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            minimumSize: MaterialStateProperty.resolveWith<Size>(
                              (Set<MaterialState> states) {
                                return const Size(100, 50);
                              },
                            ),
                          ),
                          child: const Text("Sign up"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
