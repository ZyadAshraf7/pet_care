import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/models/orders.dart';

import '../../constants/colors.dart';
import '../../models/product.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<OrderModel> userOrders = [];

  fetchUserOrders() async {
    try {
      String? phone = await FirebaseAuth.instance.currentUser?.phoneNumber;
      final doc =
      await FirebaseFirestore.instance.collection("orders").doc(phone).get();
      final List<dynamic> responseData = doc.data()!['userOrders'];
      userOrders = responseData.map((e) => OrderModel.fromJson(e)).toList();
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders",style: TextStyle(color: Colors.white,fontSize: 21)),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: FutureBuilder(
        future: fetchUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: ListView.builder(
                shrinkWrap: false,
                itemCount: userOrders.length,
                itemBuilder: (context, i) {
                  OrderModel order = userOrders[i];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      // border: Border(left: BorderSide(color: AppColors.deepGrey),top: BorderSide(color: AppColors.deepGrey),bottom: BorderSide(color: AppColors.deepGrey))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Placed on ${order.dateTime?.substring(0,10)}",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w800)),
                            GestureDetector(
                                onTap: (){
                                  setState(() {
                                    userOrders.removeWhere((element) {
                                      return element.dateTime==order.dateTime;
                                    });
                                    FirebaseFirestore.instance.collection("orders").doc(FirebaseAuth.instance.currentUser?.phoneNumber).update(
                                        {
                                          "userOrders":FieldValue.arrayRemove([order.toJson()]),
                                        });
                                  });
                                },
                                child: const Icon(Icons.cancel_outlined,color: Colors.red,))
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 110,
                          child: ListView.builder(
                            shrinkWrap: false,
                            scrollDirection: Axis.horizontal,
                            itemCount: order.products?.length,
                              itemBuilder: (context,i){
                              Product product = order.products![i];
                            return Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.network(product.imageUrl??"",height: 100,width: 100),
                                      const SizedBox(width: 8),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 150,child: Text(product.name??"",maxLines: 2,overflow: TextOverflow.ellipsis,style: const TextStyle(fontWeight: FontWeight.w600))),
                                          const SizedBox(height: 10),
                                          Text("${product.price?.toStringAsFixed(2)} EGP",style: const TextStyle(fontWeight: FontWeight.w600))
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        Text("Order Price: ${order.orderPrice!.toStringAsFixed(2)} EGP",style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)

                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
