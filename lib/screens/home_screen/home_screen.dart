import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/screens/appointments_screen/appointments_screen.dart';
import 'package:pet_care/screens/market_screen/market_screen.dart';
import 'package:pet_care/widgets/product_card.dart';

import '../../constants/colors.dart';
import '../../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text("Pet Care",style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const AppointmentsScreen()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color:AppColors.primaryBlue)
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 12).copyWith(right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 100,height: 100,child: Image.asset("assets/images/image1.jpg",fit: BoxFit.contain,)),
                      const Text("Appointments",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const MarketScreen()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color:AppColors.primaryBlue)
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 12).copyWith(right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 100,height: 100,child: Image.asset("assets/images/image2.jpg",fit: BoxFit.contain,)),
                      // const SizedBox(width: 40),
                      const Text("Market",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
              /*ElevatedButton(onPressed: (){
                Product product = Product(
                  name: "Arm & Hammer for Pets Super Deodorizing Spray for Dogs",
                  imageUrl: "https://m.media-amazon.com/images/I/710Myx0nd4L._AC_SL1500_.jpg",
                  price: 190.00
                );
                FirebaseFirestore.instance.collection("products").doc("accessories").set(
                    {
                      "accessoriesProducts":FieldValue.arrayUnion([product.toJson()])
                    },SetOptions(merge: true));
              }, child: const Text("Push Data"))*/
            ],
          ),
        ),
      )
    );
  }
}

