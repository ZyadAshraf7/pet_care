import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/screens/accessories_products_screen/accessories_products_screen.dart';
import 'package:pet_care/screens/food_products_screen/food_products_screen.dart';
import 'package:pet_care/screens/medicine_products_screen/medicine_products_screen.dart';

import '../../constants/colors.dart';
import '../../models/product.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products Categories",style: TextStyle(color: Colors.white,fontSize: 21)),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const FoodProductsScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(width: 100,height: 100,child: Image.asset("assets/images/food.jpg")),
                    const SizedBox(width: 10),
                    const Text("Food Products",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700))
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const MedicineProductsScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(width: 100,height: 100,child: Image.asset("assets/images/medicine.jpg")),
                    const SizedBox(width: 10),
                    const Text("Medicine Products",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700))
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const AccessoriesProductsScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(width: 100,height: 100,child: Image.asset("assets/images/accessories.jpg")),
                    const SizedBox(width: 10),
                    const Text("Accessories Products",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
