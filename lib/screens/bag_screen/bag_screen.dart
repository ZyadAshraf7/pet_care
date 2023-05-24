import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_care/constants/colors.dart';
import 'package:pet_care/models/orders.dart';
import 'package:pet_care/models/user_model.dart';
import 'package:pet_care/widgets/product_card.dart';

import '../../models/product.dart';

class BagScreen extends StatefulWidget {
  const BagScreen({Key? key}) : super(key: key);

  @override
  State<BagScreen> createState() => _BagScreenState();
}

class _BagScreenState extends State<BagScreen> {
  List<Product>productsInBag = [];
  fetchProductInBag()async{
    if(productsInBag.isEmpty) {
      final doc = await FirebaseFirestore.instance
          .collection("userBag")
          .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
          .get();
      List<dynamic> bag = doc.get("userBag");
      productsInBag = bag.map((e) => Product.fromJson(e)).toList();
      return productsInBag;
    }
  }
  removeProductFromBag(Product product){
    productsInBag.removeWhere((element) => element.name==product.name);
    FirebaseFirestore.instance.collection("userBag").doc(FirebaseAuth.instance.currentUser?.phoneNumber).update(
        {
          "userBag":FieldValue.arrayRemove([product.toJson()]),
        });
  }
  checkIfProductInBag(Product product){
    final bool isExist = productsInBag.any((element) => element.name==product.name);
    if (isExist) {
      return true;
    } else {
      return false;
    }
  }

    double calculateTotalPrices(){
      double totalPrice = 0;
      for (var element in productsInBag) {
        totalPrice+=(element.price!);
      }
      totalPrice.toDouble();
      // emit(TotalPriceChange());
      return totalPrice;
  }
  TextEditingController location = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bag",style: TextStyle(color: Colors.white,fontSize: 21)),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: FutureBuilder(
        future: fetchProductInBag(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 12).copyWith(bottom: 0),
                    gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                  ), itemBuilder: (context,i){
                      Product product = productsInBag[i];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  SizedBox(
                                    height: 600,
                                    width: 500,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          product.imageUrl ?? "",
                                          fit: BoxFit.contain,
                                        )),
                                  ),
                                  Positioned(
                                    child: Container(
                                      padding:const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: AppColors.primaryBlue,
                                      ),
                                      child: GestureDetector(onTap: (){
                                        setState(() {
                                          removeProductFromBag(product);
                                        });
                                      },child: const Icon(Icons.shopping_bag,color: Colors.white),),

                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: Text(
                                product.name ?? "",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            // const SizedBox(height: 8),
                            Text(
                              "${product.price} EGP",
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },itemCount: productsInBag.length),
                ),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12),height: 85,color:Colors.grey.shade200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text("Total Price: ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 16)),
                        Text("${calculateTotalPrices().toStringAsFixed(2)} EGP",style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
                      ],
                    ),
                    ElevatedButton(onPressed: (){
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          scrollable: true,
                          title: const Text("Confirm Checkout",style: TextStyle(fontWeight: FontWeight.bold),),
                          content: Column(
                            children: [
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: location,
                                decoration: const InputDecoration(hintText: "Location",prefixIcon: Icon(Icons.location_on_outlined)),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(onPressed: ()async{
                              if(location.text.isNotEmpty){
                                String? phone =await FirebaseAuth.instance.currentUser?.phoneNumber;
                                final doc = await FirebaseFirestore.instance.collection("users").doc(phone).get();
                                final data = doc.data();
                                final userInfo = UserModel.fromJson(data!);
                                DateTime now = DateTime.now();
                                String formattedDate = DateFormat('yyyy-MM-dd').format(now);
                                OrderModel order = OrderModel(phoneNumber: phone,location: location.text
                                    ,products: productsInBag,userName: userInfo.name,orderPrice: calculateTotalPrices(),
                                  dateTime: now.toIso8601String(),
                                );
                                FirebaseFirestore.instance.collection("orders").doc(phone).set(
                                    {
                                      "userOrders": FieldValue.arrayUnion([order.toJson()]),
                                    },SetOptions(merge: true)).then((value){
                                  Navigator.of(context).pop();
                                  setState(() {
                                    productsInBag.clear();
                                     FirebaseFirestore.instance
                                        .collection("userBag")
                                        .doc(FirebaseAuth.instance.currentUser!.phoneNumber).delete();
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Order is Done Successfully"),backgroundColor: Colors.green));
                                });

                              }else{
                                // Navigator.of(context).pop();
                              }
                            }, child: const Text("Confirm")),
                            TextButton(onPressed: (){
                              Navigator.of(context).pop();
                            }, child: const Text("Cancel"))

                          ],
                        );
                      });
                    },style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(
                          AppColors.primaryBlue),
                    ), child: const Text("Checkout",style: TextStyle(color: Colors.white)),)
                  ],
                )),

              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      )
    );
  }
}
