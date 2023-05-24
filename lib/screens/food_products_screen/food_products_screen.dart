import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';

class FoodProductsScreen extends StatefulWidget {
  const FoodProductsScreen({Key? key}) : super(key: key);

  @override
  State<FoodProductsScreen> createState() => _FoodProductsScreenState();
}

class _FoodProductsScreenState extends State<FoodProductsScreen> {

  List<Product> products = [];

  fetchProducts()async{
    try {
      if(products.isEmpty) {
        final doc = await FirebaseFirestore.instance
            .collection("products")
            .doc("food")
            .get();
        final response = doc.data();
        final List<dynamic> productsResponse = response!["foodProducts"];
        products = productsResponse.map((e) => Product.fromJson(e)).toList();
        return products;
      }
    }catch(e){
      print(e.toString());
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Section",style: TextStyle(color: Colors.white,fontSize: 21)),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: FutureBuilder(
        future: fetchProducts(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 12).copyWith(bottom: 0),
                child: GridView.builder(gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10
                ), itemBuilder: (context,i){
                  return ProductCard(product: products[i],);
                },itemCount: products.length,),
              ),
            );
          }else{
            const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
