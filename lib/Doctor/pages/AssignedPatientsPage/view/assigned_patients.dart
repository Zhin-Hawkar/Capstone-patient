import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Doctor/pages/AssignedPatientsPage/controller/assigned_patients_controller.dart';
import 'package:capstone/Doctor/pages/AssignedPatientsPage/model/assigned_patients_model.dart';
import 'package:capstone/Reusables/AppBar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class AssignedPatients extends ConsumerStatefulWidget {
  const AssignedPatients({super.key});

  @override
  ConsumerState<AssignedPatients> createState() => _AssignedPatientsState();
}

class _AssignedPatientsState extends ConsumerState<AssignedPatients> {
  List<AssignedPatientsModel> appointments = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    setState(() {
      isLoading = true;
    });
    final result = await showAppointments();
    setState(() {
      appointments = result;
      isLoading = false;
    });
  }

  Future<dynamic> showAppointments() async {
    List<AssignedPatientsModel> result =
        await AssignedPatientsController.handleAcceptedAppointments();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: CustomAppBar(title: "Patients"),
      drawer: CustomDoctorDrawer(),
      body: Column(
        children: [
          Expanded(
            child: appointments.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key("${appointments[index].firstName}"),
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
                                '${appointments[index].firstName} dismissed',
                              ),
                            ),
                          );
                          setState(() {
                            appointments.removeAt(index);
                          });
                        },
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm Delete"),
                                content: Text(
                                  "Are you sure you want to delete ${appointments[index].firstName}?",
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
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 2.w,
                            right: 2.w,
                            top: 2.h,
                          ),
                          child: PatientCard(patient: appointments[index]),
                        ),
                      );
                    },
                  )
                : isLoading
                ? Center(
                    child: Transform.scale(
                      scale: 1.6,
                      child: Lottie.asset(
                        "assets/json/Material wave loading.json",
                        width: 100,
                        height: 100,
                      ),
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
              child: Image.network(
                "${patient.image}",
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
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
