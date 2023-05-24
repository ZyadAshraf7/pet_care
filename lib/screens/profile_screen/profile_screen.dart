import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_care/screens/login_screen/login_screen.dart';
import 'package:pet_care/screens/my_appointments/my_appointments.dart';
import 'package:pet_care/screens/my_orders/my_orders.dart';
import 'package:pet_care/shared_preference/user_preference.dart';

import '../../constants/colors.dart';
import '../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<UserModel>fetchUserInfo()async{
    final doc = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.phoneNumber).get();
    final data = doc.data();
    UserModel userInfo = UserModel.fromJson(data!);
    return userInfo;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile",style: TextStyle(color: Colors.white,fontSize: 21)),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchUserInfo(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(snapshot.data?.name??""),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(snapshot.data?.email??""),
                    ),
                    ListTile(
                      leading: const Icon(Icons.call),
                      title: Text(snapshot.data?.phoneNumber??""),
                    ),
                    ListTile(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const MyOrders()));
                      },
                      leading: const Icon(Icons.payment_outlined),
                      title: const Text("My Orders"),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                    ListTile(
                      onTap: ()async{
                        await UserPreferences.logUserOut();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>const LoginScreen()));
                      },
                      leading: const Icon(Icons.logout,color: Colors.red,),
                      title: const Text("Logout",style: TextStyle(color: Colors.red),),
                    ),
                  ],
                ),
              );
            }else{
              return const CircularProgressIndicator();
            }
          }

        ),
      ),
    );
  }
}
