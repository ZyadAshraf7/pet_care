class Doctor {
  String? name;
  String? bio;
  String? imageUrl;
  String? phoneNumber;
  double? fees;
  double? followupFees;
  List<String>? daysAvailable;
  List<String>? timeAvailable;

  Doctor(
      {this.name,
      this.bio,
      this.imageUrl,
      this.phoneNumber,
      this.fees,
      this.followupFees,
      this.daysAvailable,
      this.timeAvailable});

  Doctor.fromJson(Map<String,dynamic>json){
    name = json["name"];
    bio = json["bio"];
    imageUrl = json["imageUrl"];
    phoneNumber = json["phoneNumber"];
    fees = (json["fees"]as num).toDouble();
    followupFees = (json["followupFees"]as num).toDouble();
    daysAvailable = json["daysAvailable"].cast<String>();
    timeAvailable = json["timeAvailable"].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["name"]=this.name;
    data["bio"]=this.bio;
    data["imageUrl"]=this.imageUrl;
    data["phoneNumber"]=this.phoneNumber;
    data["fees"]=this.fees;
    data["followupFees"]=this.followupFees;
    data["daysAvailable"]=this.daysAvailable;
    data["timeAvailable"]=this.timeAvailable;
    return data;
  }
}

