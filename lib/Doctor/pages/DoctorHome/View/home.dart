import 'dart:convert';

import 'package:capstone/Backend/PusherSocket/pusher_notification.dart';
import 'package:capstone/Constants/enum.dart';
import 'package:capstone/Doctor/pages/AssignedPatientsPage/controller/assigned_patients_controller.dart';
import 'package:capstone/Doctor/pages/AssignedPatientsPage/model/assigned_patients_model.dart';
import 'package:capstone/Doctor/pages/AssignedPatientsPage/view/patient_profile_view_page.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Controller/doctor_notification.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Model/doctor_notification.dart';
import 'package:capstone/Doctor/pages/Statistics/Controller/statistics_controller.dart';
import 'package:capstone/Doctor/pages/Statistics/Model/statistics_model.dart';
import 'package:capstone/Patient/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:capstone/Reusables/AppBar/app_bar.dart';
import 'package:capstone/SharedResources/global_storage_service.dart';
import 'package:capstone/Backend/Model/user_model.dart';
import 'package:capstone/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class DoctorHome extends ConsumerStatefulWidget {
  const DoctorHome({super.key});

  @override
  ConsumerState<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends ConsumerState<DoctorHome> {
  List<AssignedPatientsModel> appointments = [];
  StatisticsModel? statistics = StatisticsModel();
  bool isLoading = false;
  List<dynamic> socketresult = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAppointments();
    loadStatistics();
    if (GlobalStorageService.storageService
        .getString(EnumValues.ACCESS_TOKEN)
        .isNotEmpty) {
      setupSocket();
    }
  }

  Future<void> refresh() async {
    await loadAppointments();
    await loadStatistics();
    setupSocket();
  }

  Future<void> loadStatistics() async {
    setState(() {
      isLoading = true;
    });
    StatisticsModel result = await getStatistics();
    setState(() {
      statistics = result;
      isLoading = false;
    });
  }

  void setupSocket() {
    NotificationService.init(context, channelName: "doctor");
  }

  Future<dynamic> getStatistics() async {
    StatisticsModel result = await StatisticsController.handleStatistics();
    return result;
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
  void dispose() {
    if (GlobalStorageService.storageService
        .getString(EnumValues.ACCESS_TOKEN)
        .isNotEmpty) {
      NotificationService.disconnect(channelName: "doctor");
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doctor = ref.watch(signInNotifierProvider);
    return Scaffold(
      appBar: CustomAppBar(title: "Doctor Dashboard"),
      drawer: CustomDoctorDrawer(),
      backgroundColor: AppColors.WHITE_BACKGROUND,
      body: RefreshIndicator(
        onRefresh: () {
          return refresh();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, Dr. ${doctor.doctor?.firstName ?? ""}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.DARK_GREEN,
                ),
              ),
              SizedBox(height: 3.h),

              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Assigned Patients',
                      value: "${statistics?.patients ?? 0}",
                      icon: Icons.people_alt_rounded,
                      color: AppColors.DARK_GREEN,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: StatCard(
                      title: 'Pending Requests',
                      value: "${statistics?.requests ?? 0}",
                      icon: Icons.pending_actions_rounded,
                      color: Colors.orange[600] ?? Colors.orange,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                'Assigned Patients',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.DARK_GREEN,
                ),
              ),
              SizedBox(height: 1.5.h),
              if (appointments.isEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 32.sp,
                        color: Colors.grey[600],
                      ),
                      SizedBox(height: 1.5.h),
                      Text(
                        'No patients assigned yet.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appointments.length,
                  separatorBuilder: (_, __) => SizedBox(height: 2.h),
                  itemBuilder: (context, index) {
                    final patient = appointments[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: PatientProfileViewPage(patient: patient),
                          ),
                        );
                      },

                      child: PatientCard(patient: patient),
                    );
                  },
                ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            height: 6.h,
            width: 6.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 24.sp),
          ),
          SizedBox(width: 3.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
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
