import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/constants/colors.dart';

import '../models/product.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  List<Product>productsInBag = [];
  fetchProductInBag()async{
    final doc = await FirebaseFirestore.instance.collection("userBag").doc(FirebaseAuth.instance.currentUser!.phoneNumber).get();
    List<dynamic>bag =doc.get("userBag");
    productsInBag =bag.map((e) => Product.fromJson(e)).toList();
    return productsInBag;
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
  addProductToBag(Product product){
    productsInBag.insert(0, product);
    FirebaseFirestore.instance.collection("userBag").doc(FirebaseAuth.instance.currentUser!.phoneNumber).set({
      "userBag":FieldValue.arrayUnion([product.toJson()]),
    },SetOptions(merge: true));
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchProductInBag(),
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.done){
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
                                widget.product.imageUrl ?? "",
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
                              if(checkIfProductInBag(widget.product)){
                                setState(() {
                                  removeProductFromBag(widget.product);
                                });
                              }else{
                                setState(() {
                                  addProductToBag(widget.product);
                                });
                              }
                            },child: Icon(checkIfProductInBag(widget.product)?Icons.shopping_bag:Icons.shopping_bag_outlined,color: Colors.white)),

                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Text(
                      widget.product.name ?? "",
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
                    "${widget.product.price} EGP",
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
        }else{
          return const Center(child: SizedBox(),);
        }
      },
    );
  }
}
