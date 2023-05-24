import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/constants/colors.dart';
import 'package:pet_care/models/appointment.dart';

class MyAppointments extends StatefulWidget {
  const MyAppointments({Key? key}) : super(key: key);

  @override
  State<MyAppointments> createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  List <Appointment>appointmentsList=[];
  fetchUserAppointments()async{
    final doc = await FirebaseFirestore.instance.collection("userAppointments").doc(FirebaseAuth.instance.currentUser?.phoneNumber).get();
    final data = doc.data();
    final List<dynamic>responseData = data!["userAppointments"];
    appointmentsList = responseData.map((e) => Appointment.fromJson(e)).toList();
    return appointmentsList;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings",style: TextStyle(color: Colors.white,fontSize: 21)),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: FutureBuilder(
        future: fetchUserAppointments(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return ListView.builder(
                itemCount: appointmentsList.length,
                itemBuilder: (context,i){
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.calendar_month,color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(appointmentsList[i].appointmentDay??"",style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: AppColors.primaryBlue)),
                            const SizedBox(width: 35),
                            const Icon(Icons.timelapse,color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(appointmentsList[i].appointmentTime??"",style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: AppColors.primaryBlue)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text("Doctor: ${appointmentsList[i].relatedDoctor?.name}",style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        Text("Fees: ${appointmentsList[i].relatedDoctor?.fees?.toStringAsFixed(2)} EGP"),
                        Text("Followup Fees: ${appointmentsList[i].relatedDoctor?.followupFees?.toStringAsFixed(2)} EGP"),
                      ],
                    ),
                  ),
                ),
              );
            });
          }else{
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }
}
