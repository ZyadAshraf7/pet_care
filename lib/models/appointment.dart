import 'package:pet_care/models/doctor.dart';

class Appointment {
  Doctor? relatedDoctor;
  String? appointmentDay;
  String? appointmentTime;
  // String? appointmentStatus;

  Appointment(
      {this.relatedDoctor,
      this.appointmentDay,
      this.appointmentTime,
      /*this.appointmentStatus*/});

  Appointment.fromJson(Map<String,dynamic>json){
    relatedDoctor = Doctor.fromJson(json["relatedDoctor"]);
    appointmentTime = json['appointmentTime'];
    appointmentDay = json['appointmentDay'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['relatedDoctor']=this.relatedDoctor?.toJson();
    data['appointmentDay']=this.appointmentDay;
    data['appointmentTime']=this.appointmentTime;
    // data['appointmentStatus']=this.appointmentStatus;
    return data;
  }
}