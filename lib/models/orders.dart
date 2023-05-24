import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_care/models/product.dart';

class OrderModel{
  String ?userName;
  String ?location;
  String ?phoneNumber;
  List<Product>?products;
  double ?orderPrice;
  String ?dateTime;

  OrderModel({this.userName, this.location, this.products,this.phoneNumber,this.orderPrice,this.dateTime});

  OrderModel.fromJson(Map<String,dynamic>json){
    userName = json['name'];
    phoneNumber = json['phoneNumber'];
    location = json['location'];
    var productsList = json['products'] as List<dynamic>;
    products = productsList.map((e) => Product.fromJson(e)).toList();
    orderPrice = (json['orderPrice'] as num).toDouble();
    dateTime = json['dateTime'];/*DateTime.parse(json['dateTime']).toIso8601String().substring(0, 10);*/
  }
  Map<String,dynamic>toJson(){
    Map<String,dynamic>data = Map<String,dynamic>();
    data['name']=userName;
    data['phoneNumber']=phoneNumber;
    data['location']=location;
    data['products']=products?.map((e) => e.toJson());
    data['orderPrice']=orderPrice;
    data['dateTime']=dateTime;
    return data;
  }
}