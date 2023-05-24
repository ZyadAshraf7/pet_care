import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/constants/colors.dart';
import 'package:pet_care/models/user_model.dart';
import 'package:pet_care/screens/register_screen/register_screen.dart';

import '../register_screen/phone_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginKey = GlobalKey<FormState>();
  TextEditingController phoneNumber = TextEditingController();
  String verificationID = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Form(
            key:_loginKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                    child: Text(
                  "Pet Care",
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                )),
                const SizedBox(height: 50),
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
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () async{
                        if(_loginKey.currentState!.validate()){
                          print("valid");
                          String phoneNumberFormatted = "+2${phoneNumber.text}";
                          final doc = await FirebaseFirestore.instance.collection("users").get();
                          List<String>usersNumbers=[];
                          for (int i =0;i<doc.docs.length;i++){
                            usersNumbers.add(doc.docs[i].id);
                          }
                          if(!usersNumbers.contains(phoneNumberFormatted)){
                            //user does not exist
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("phone number does not exist"),backgroundColor: Colors.red,));
                          }else{
                            //user exist
                          print("phone Number !! ${phoneNumberFormatted}");
                          FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: phoneNumberFormatted,
                            timeout: const Duration(seconds: 60),
                            verificationCompleted:
                                (PhoneAuthCredential credential) async {
                              await FirebaseAuth.instance.signInWithCredential(credential);
                              print("Verification Completed");
                            },
                            verificationFailed: (FirebaseAuthException e) {
                              print(e.toString());
                            },
                            codeSent: (String verificationId,
                                int? resendToken) async {
                              // emit(VerificationLoading());
                              verificationID = verificationId;
                              print("code sent function");
                              final doc = await FirebaseFirestore.instance.collection("users").doc(phoneNumberFormatted).get();
                              final data = await doc.data();
                              UserModel userInfo = UserModel.fromJson(data!);
                              print(userInfo.name);
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (_) => PhoneVerificationScreen(
                                      user: userInfo,
                                      isRegister: false,
                                      verificationID: verificationID)));
                              // emit(VerificationSuccess());
                            },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {
                              //verificationID = verificationId;
                            },
                          );
                          }
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.primaryBlue),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.resolveWith<Size>(
                            (Set<MaterialState> states) {
                          return const Size(100, 50);
                        }),
                      ),
                      child: const Text("Login"),
                    )),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>RegisterScreen()));
                        },
                        child: const Text(
                          "Create an account",
                          style: TextStyle(color: AppColors.primaryBlue),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
