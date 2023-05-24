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

/*{
  "name": "John Matthews",
  "phoneNumber": "+201050235569",
  "bio": "Dr. John Matthews is a highly experienced and compassionate veterinarian with a deep passion for animal care. With over 20 years of dedicated service, he has become a trusted name in the veterinary community. Driven by his love for animals and their well-being, he pursued a career in veterinary medicine after witnessing the positive impact veterinarians can have on both animals and their owners.",
  "imageUrl":"http://dummyimage.com/190x100.png/cc0000/ffffff",
  "fees": 140,
  "daysAvailable": [
    "Sunday",
    "Monday"
  ],
  "timeAvailable": [
    "2:00 PM",
    "11:00 AM"
  ]
}
*/
