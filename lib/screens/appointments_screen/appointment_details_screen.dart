import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:pet_care/models/appointment.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../models/doctor.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({Key? key, required this.doctorAppointment})
      : super(key: key);
  final Doctor doctorAppointment;

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  String selectedDay = "";
  String selectedTime = "";
  bool isSelected = false;
  Color selectedTextColor = Colors.white;
  Color selectedBackgroundColor = AppColors.primaryBlue;
  TextEditingController promoCode = TextEditingController();
  String validPromoCode="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book an appointment",
            style: TextStyle(color: Colors.white, fontSize: 21)),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        foregroundImage: NetworkImage(
                            widget.doctorAppointment.imageUrl!),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.doctorAppointment.name!,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.doctorAppointment.bio!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                            ),
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
                          validPromoCode=="valid"?Row(
                            children: [
                              const Text("Fees",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                              const SizedBox(width: 6),
                              Text(
                                  "${widget.doctorAppointment.fees?.toStringAsFixed(2)} EGP",
                                  style: const TextStyle(fontSize: 16,decoration: TextDecoration.lineThrough)),
                              const SizedBox(width: 6),
                              Text(
                                  "${((widget.doctorAppointment.fees)!*0.8).toStringAsFixed(2)} EGP",
                                  style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.green)),
                            ],
                          )
                              :Text(
                              "Fees ${widget.doctorAppointment.fees?.toStringAsFixed(2)} EGP",
                              style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(
                            "Follow up ${widget.doctorAppointment.followupFees?.toStringAsFixed(2)} EGP",
                            style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 14),
                          InkWell(
                            onTap: ()async{
                               await FlutterPhoneDirectCaller.callNumber(widget.doctorAppointment.phoneNumber.toString());
                            },
                            child: Row(
                              children:  [
                                const Icon(Icons.call,color: AppColors.primaryBlue),
                                const SizedBox(width: 8),
                                Text(widget.doctorAppointment.phoneNumber.toString(),style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: AppColors.primaryBlue))
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 40),
              const Text("Select Appointment Day",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 6,
                  children: widget.doctorAppointment.daysAvailable!.map(
                    (product) {
                      return GestureDetector(
                        onTap: (){
                          print(product);
                          setState(() {
                            selectedDay = product;
                          });
                        },
                        child: Chip(
                          label: Text(product,
                              style: TextStyle(color: selectedDay==product?Colors.white :AppColors.primaryBlue)),
                          backgroundColor: selectedDay==product?AppColors.primaryBlue :Colors.transparent,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(color: AppColors.primaryBlue),
                              borderRadius: BorderRadius.circular(20)),

                        ),
                      );
                    },
                  ).toList()),
              const SizedBox(height: 30),
              const Text("Select Appointment Time",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 6,
                  children: widget.doctorAppointment.timeAvailable!.map(
                    (product) {
                      return GestureDetector(
                        onTap: (){
                          setState(() {
                            selectedTime = product;
                          });
                        },
                        child: Chip(
                          label: Text(product,
                              style: TextStyle(color: selectedTime==product?Colors.white :AppColors.primaryBlue)),
                          backgroundColor: selectedTime==product?AppColors.primaryBlue :Colors.transparent,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(color: AppColors.primaryBlue),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      );
                    },
                  ).toList()),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: promoCode,
                      decoration: const InputDecoration(hintText: "Promo Code"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async{
                      if(promoCode.text.isNotEmpty) {
                        final doc = await FirebaseFirestore.instance
                            .collection("promoCodes")
                            .doc("promo")
                            .get();
                        final data = doc.data();
                        List<String> promoCodesList = data?["promoCodes"].cast<String>();
                        if (promoCodesList.contains(promoCode.text)) {
                          setState(() {
                            validPromoCode = "valid";
                          });
                        } else {
                          setState(() {
                            validPromoCode="invalid";
                          });
                        }
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(AppColors.primaryBlue)),
                    child: const Text("APPLY"),
                  )
                ],
              ),
              validPromoCode!=""?Column(
                  children: [
                const SizedBox(height: 5),
                validPromoCode=="valid"?const Text("Your promo code is valid",style: TextStyle(color: Colors.green)):const Text("Your promo code is invalid",style: TextStyle(color: Colors.red))
              ]):const SizedBox(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if(selectedDay==""||selectedTime==""){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Appointment day and time must be selected"),backgroundColor: Colors.red));
                        }else{
                          FirebaseFirestore.instance.collection("userAppointments").doc(FirebaseAuth.instance.currentUser?.phoneNumber).set(
                              {
                                "userAppointments":FieldValue.arrayUnion([Appointment(relatedDoctor: widget.doctorAppointment,appointmentDay: selectedDay,appointmentTime: selectedTime).toJson()])
                              },SetOptions(merge: true)).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Appointment is created successfully"),backgroundColor: Colors.green,));
                          });
                        }
                      },
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.resolveWith<Size>(
                                  (Set<MaterialState> states) {
                                return const Size(100, 55);
                              }
                          ),
                          backgroundColor:
                          MaterialStateProperty.all(AppColors.primaryBlue)),
                      child: const Text("Book Appointment",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
