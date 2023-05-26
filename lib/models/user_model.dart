import 'package:pet_care/models/appointment.dart';

class UserModel{
  String? name;
  String? email;
  String?phoneNumber;

  UserModel(
      {this.name,
      this.email,
      this.phoneNumber});

  UserModel.fromJson(Map<String,dynamic>json){
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }
  Map<String,dynamic>toJson(){
    Map<String,dynamic>data = Map<String, dynamic>();
    data['name'] = name;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}