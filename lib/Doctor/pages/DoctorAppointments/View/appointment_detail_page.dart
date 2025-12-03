import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Doctor/pages/AssignedPatientsPage/model/assigned_patients_model.dart';
import 'package:capstone/FileManipulation/UploadFiles/view_file.dart';
import 'package:capstone/Patient/Pages/Appointments/Controller/appointments_controller.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class AppointmentDetailsPage extends StatefulWidget {
  AssignedPatientsModel acceptedAppointments;
  AppointmentDetailsPage({super.key, required this.acceptedAppointments});

  @override
  State<AppointmentDetailsPage> createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {
  String documentUrl = "";
  void showDoctorLegalDocument() async {
    String result = await AppointmentController.handleDoctorLegalDocument(
      widget.acceptedAppointments.patientId,
    );
    setState(() {
      documentUrl = result;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showDoctorLegalDocument();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 5.w),
                  child: Text(
                    "Appointment",
                    style: TextStyle(
                      color: AppColors.DARK_GREEN,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 5.w, top: 5.h),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(25),
                    child: widget.acceptedAppointments.image != null
                        ? Image.network(
                            "${widget.acceptedAppointments.image}",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.person_2),
                  ),
                ),
                SizedBox(width: 5.w),
                Container(
                  margin: EdgeInsets.only(top: 4.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Patient: ${widget.acceptedAppointments.firstName} ${widget.acceptedAppointments.lastName}",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 1.h),
                      Text("Age: ${widget.acceptedAppointments.age}"),
                      SizedBox(height: 1.h),
                      Text("Gender: ${widget.acceptedAppointments.gender}"),
                      SizedBox(height: 1.h),
                      Text("email: ${widget.acceptedAppointments.email}"),
                      SizedBox(height: 1.h),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 5.w),
                  child: Text(
                    "Assigned Doctor",
                    style: TextStyle(color: AppColors.DARK_GREEN, fontSize: 20),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 2.h, left: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Doctor: ${widget.acceptedAppointments.doctorFirstName} ${widget.acceptedAppointments.doctorLastName}",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "Department: ${widget.acceptedAppointments.department}",
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "Hospital: ${widget.acceptedAppointments.hospitalName}",
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "Hospital Location: ${widget.acceptedAppointments.hospitalLocation}",
                      ),
                      SizedBox(height: 1.h),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 5.w),
                  child: Text(
                    "Patient need",
                    style: TextStyle(color: AppColors.DARK_GREEN, fontSize: 20),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 2.h, left: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.acceptedAppointments.help}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 5.w),
                  child: Text(
                    "Appointment Date",
                    style: TextStyle(color: AppColors.DARK_GREEN, fontSize: 20),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 2.h, left: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.acceptedAppointments.date_time?.day}/${widget.acceptedAppointments.date_time?.month}/${widget.acceptedAppointments.date_time?.year}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 5.w),
                  child: Text(
                    "Appointment Status",
                    style: TextStyle(color: AppColors.DARK_GREEN, fontSize: 20),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 2.h, left: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.acceptedAppointments.status}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 5.w),
                  child: Text(
                    "Legal Agreement",
                    style: TextStyle(color: AppColors.DARK_GREEN, fontSize: 20),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 5.w, top: 3.h, bottom: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: FileViewer(pdfUrl: documentUrl),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.DARK_GREEN,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 120,
                      height: 120,
                      child: Icon(
                        Icons.file_copy,
                        color: AppColors.WHITE_BACKGROUND,
                        size: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
