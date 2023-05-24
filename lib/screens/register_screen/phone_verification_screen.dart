import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/constants/colors.dart';
import 'package:pet_care/models/user_model.dart';
import 'package:pet_care/screens/bottom_nav_bar/bottom_nav_bar.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen(
      {Key? key, required this.user,required this.verificationID, required this.isRegister})
      : super(key: key);
  final UserModel user;
final String verificationID;
final bool isRegister;
  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _verificationForm = GlobalKey<FormState>();
  TextEditingController code = TextEditingController();
  // String verificationID = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xfff5f5f5),
                  border: Border.all(color: AppColors.primaryBlue),
                ),
                child: Form(
                  key: _verificationForm,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("We have sent a verification code to\n${widget
                          .user.phoneNumber}", textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),),
                      const SizedBox(height: 15),
                      const Text("Enter the 6 digit code below"),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: code,
                        validator: (value) {
                          const codeLength = 6;
                          if (value == null || value.isEmpty) {
                            return 'Code is required';
                          }
                          if (value.length < codeLength) {
                            return 'Code must be at least $codeLength numbers long';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: "Add Code"
                        ),
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (val) async {

                        },
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(child: ElevatedButton(onPressed: ()async {
                            if (_verificationForm.currentState!.validate()) {
                              print("valid");
                              print(widget.verificationID);
                              UserCredential credential =
                                  await FirebaseAuth.instance.signInWithCredential(
                                PhoneAuthProvider.credential(
                                    verificationId: widget.verificationID, smsCode: code.text),
                              );
                              if(credential.user!=null){
                                // print("SUCCESS");
                                if(widget.isRegister){
                                  await FirebaseFirestore.instance.collection('users').doc(widget.user.phoneNumber).set(widget.user.toJson());
                                    print('User added successfully!');
                                }
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>const BottomNavBar()),(Route<dynamic> route) => false,);
                              }
                            }
                          },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                    Color>(
                                    AppColors.primaryBlue)
                            ),
                            child: const Text("Verify",
                                style: TextStyle(color: Colors.white)),)),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
