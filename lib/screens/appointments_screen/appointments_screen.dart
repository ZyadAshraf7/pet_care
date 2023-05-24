import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/constants/colors.dart';
import 'package:pet_care/models/appointment.dart';
import 'package:pet_care/models/doctor.dart';
import 'package:pet_care/screens/appointments_screen/appointment_details_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<Doctor> doctorsAppointments = [];

  fetchAppointments()async{
    try {
      if(doctorsAppointments.isEmpty) {
        final doc = await FirebaseFirestore.instance
            .collection("appointments")
            .doc("availableAppointments")
            .get();
        final response = doc.data();
        final List<dynamic> appointmentsResponse = response!["doctorsAppointments"];
        doctorsAppointments = appointmentsResponse.map((e) => Doctor.fromJson(e)).toList();
        return doctorsAppointments;
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
        title: const Text("Book appointment",style: TextStyle(color: Colors.white,fontSize: 21)),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: FutureBuilder(
        future: fetchAppointments(),
        builder: (context,snapShot){
          if(snapShot.connectionState==ConnectionState.done){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 12),
              child: Center(
                child: ListView.separated(
                    itemCount: doctorsAppointments.length,
                    separatorBuilder: (context,_)=>const SizedBox(height: 24),
                    itemBuilder: (context,i){
                      return GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>AppointmentDetailsScreen(doctorAppointment: doctorsAppointments[i],)));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12.withOpacity(0.015),blurRadius: 2,offset: Offset(2, 4),spreadRadius: 4)
                              ]
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CircleAvatar(
                                    foregroundImage: NetworkImage(doctorsAppointments[i].imageUrl!??""),
                                    radius: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(doctorsAppointments[i].name!,style: const TextStyle(fontWeight: FontWeight.w700),),
                                        const SizedBox(height: 4),
                                        Text(doctorsAppointments[i].bio!,overflow: TextOverflow.ellipsis,maxLines: 2,),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Fees ${doctorsAppointments[i].fees?.toStringAsFixed(2)} EGP",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 4),
                                      Text("Follow up ${doctorsAppointments[i].followupFees?.toStringAsFixed(2)} EGP",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)
                                    ],
                                  ),
                                  Spacer(),
                                  Text("Accept Promo Code",style: TextStyle(color: Colors.green),)
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            );

          }else{
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
