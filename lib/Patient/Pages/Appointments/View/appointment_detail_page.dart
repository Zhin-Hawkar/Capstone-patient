import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Doctor/pages/AssignedPatientsPage/model/assigned_patients_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PatientAppointmentDetailsPage extends StatefulWidget {
  AssignedPatientsModel acceptedAppointments;
  PatientAppointmentDetailsPage({super.key, required this.acceptedAppointments});

  @override
  State<PatientAppointmentDetailsPage> createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<PatientAppointmentDetailsPage> {
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
                    child: Image.network(
                      "${widget.acceptedAppointments.doctorImage}",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
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
          ],
        ),
      ),
    );
  }
}
