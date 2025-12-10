import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Doctor/pages/AssignedPatientsPage/model/assigned_patients_model.dart';
import 'package:capstone/Doctor/pages/DoctorAppointments/Controller/doctor_appointments.dart';
import 'package:capstone/Doctor/pages/DoctorAppointments/View/appointment_detail_page.dart';
import 'package:capstone/Reusables/AppBar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class DoctorsAppointments extends StatefulWidget {
  const DoctorsAppointments({super.key});

  @override
  State<DoctorsAppointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<DoctorsAppointments> {
  List<AssignedPatientsModel> acceptedAppointments = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showDoctorAcceptedAppointments();
  }

  Future<void> refresh() async {
    showDoctorAcceptedAppointments();
  }

  void showDoctorAcceptedAppointments() async {
    setState(() {
      isLoading = true;
    });
    List<AssignedPatientsModel> result =
        await DoctorAppointmentController.handleDoctorAcceptedAppointments();

    setState(() {
      acceptedAppointments = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: CustomAppBar(title: "Appointments"),
      drawer: CustomDoctorDrawer(),
      body: Column(
        children: [
          Expanded(
            child: acceptedAppointments.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () {
                      return refresh();
                    },
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: acceptedAppointments.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(
                            acceptedAppointments[index].firstName.toString(),
                          ),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${acceptedAppointments[index].firstName} dismissed',
                                ),
                              ),
                            );
                            setState(() {
                              acceptedAppointments.removeAt(index);
                            });
                          },
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirm Delete"),
                                  content: Text(
                                    "Are you sure you want to delete ${acceptedAppointments[index].firstName}?",
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text("CANCEL"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text("DELETE"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: AppointmentDetailsPage(
                                    acceptedAppointments:
                                        acceptedAppointments[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                left: 2.w,
                                right: 2.w,
                                top: 2.w,
                              ),
                              child: PatientCard(
                                patient: acceptedAppointments[index],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    margin: EdgeInsetsDirectional.only(bottom: 30.h),
                    child: Transform.scale(
                      scale: 0.8,
                      child: Lottie.asset("assets/json/no data found.json"),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  const PatientCard({required this.patient});

  final AssignedPatientsModel patient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(20),
            child: SizedBox(
              width: 70,
              height: 70,
              child: patient.image != null
                  ? Image.network(
                      "${patient.image}",
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.person_2),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${patient.firstName} ${patient.lastName}",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${patient.age} years',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),
                SizedBox(height: 1.5.h),
                Row(
                  children: [
                    Icon(
                      Icons.event_available,
                      size: 16.sp,
                      color: AppColors.DARK_GREEN,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Last visit: -/-/-',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.8.h),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16.sp,
                      color: AppColors.DARK_GREEN,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Next visit: ${patient.date_time}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
