import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Controller/doctor_notification.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Model/doctor_notification.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Notifier/patient_notification_response.dart';
import 'package:capstone/Patient/Pages/Appointments/View/appointment_detail_page.dart';
import 'package:capstone/Patient/Pages/Notifications/Controller/patient_notification.dart';
import 'package:capstone/Reusables/AppBar/app_bar.dart';
import 'package:capstone/Reusables/Buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  late TabController _tab_controller;
  List<DoctorNotification> notifications = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _tab_controller = TabController(length: 3, vsync: this);
    loadNotifications();
  }

  Future<void> refresh() async {
    await loadNotifications();
  }

  Future<void> loadNotifications() async {
    setState(() {
      isLoading = true;
    });
    List<DoctorNotification> result = await showNotifications();
    setState(() {
      notifications = result;
      isLoading = false;
    });
  }

  Future<dynamic> showNotifications() async {
    List<DoctorNotification> result =
        await PatientNotificationController.notifyPatient();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: CustomAppBar(title: "Notifications"),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TabBarNotificationsViewButtonOne(
                  tabController: _tab_controller,
                  buttonText: "new",
                  function: () {
                    setState(() {
                      _tab_controller.animateTo(0);
                    });
                  },
                ),
                TabBarNotificationsViewButtonTwo(
                  tabController: _tab_controller,
                  buttonText: "this week",
                  function: () {
                    setState(() {
                      _tab_controller.animateTo(1);
                    });
                  },
                ),
                TabBarNotificationsViewButtonThree(
                  tabController: _tab_controller,
                  buttonText: "earlier",
                  function: () {
                    setState(() {
                      _tab_controller.animateTo(2);
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tab_controller,
              children: [
                Column(
                  children: [
                    Expanded(
                      child: notifications.isNotEmpty
                          ? RefreshIndicator(
                              onRefresh: () {
                                return refresh();
                              },
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: notifications.length,
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    key: Key(
                                      "${notifications[index].firstName}",
                                    ),
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${notifications[index].firstName} dismissed',
                                          ),
                                        ),
                                      );
                                      setState(() {
                                        notifications.removeAt(index);
                                      });
                                    },
                                    confirmDismiss: (direction) async {
                                      return await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Confirm Delete"),
                                            content: Text(
                                              "Are you sure you want to delete ${notifications[index].firstName}?",
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.of(
                                                  context,
                                                ).pop(false),
                                                child: Text("CANCEL"),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.of(
                                                  context,
                                                ).pop(true),
                                                child: Text("DELETE"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigator.push(
                                        //   context,
                                        //   PageTransition(
                                        //     type:
                                        //         PageTransitionType.rightToLeft,
                                        //     child: AppointmentDetailsPage(
                                        //       acceptedAppointments:
                                        //           notifications[index],
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          left: 2.w,
                                          right: 2.w,
                                          top: 2.h,
                                        ),
                                        child: PatientCard(
                                          patient: notifications[index],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : isLoading
                          ? Transform.scale(
                              scale: 1.6,
                              child: Lottie.asset(
                                "assets/json/Material wave loading.json",
                                width: 100,
                                height: 100,
                              ),
                            )
                          : Container(
                              margin: EdgeInsetsDirectional.only(bottom: 30.h),
                              child: Transform.scale(
                                scale: 0.8,
                                child: Lottie.asset(
                                  "assets/json/no data found.json",
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
                Center(child: Text("no notification yet")),
                Center(child: Text("no notification yet")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PatientCard extends ConsumerStatefulWidget {
  const PatientCard({super.key, required this.patient});

  final DoctorNotification patient;

  @override
  ConsumerState<PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends ConsumerState<PatientCard> {
  bool isBtnClicked = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      patientNotificationResponseNotifierProvider.notifier,
    );
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
              child: widget.patient.doctorImage == null
                  ? Icon(Icons.person)
                  : Image.network("${widget.patient.doctorImage}"),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.patient.firstName} ${widget.patient.lastName}",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 1.5.h),
                Row(
                  children: [
                    Icon(
                      Icons.local_hospital,
                      size: 16.sp,
                      color: AppColors.DARK_GREEN,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Department: ${widget.patient.department}',
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
                        "next visit: ${widget.patient.date_time?.day}/${widget.patient.date_time?.month}/${widget.patient.date_time?.year}",
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

          isBtnClicked
              ? Container(
                  margin: EdgeInsets.only(top: 2.h, right: 3.w),
                  child: CircularProgressIndicator(),
                )
              : Container(
                  margin: EdgeInsets.only(top: 2.h),
                  child:
                      widget.patient.status == "pending" ||
                          widget.patient.status == "accepted"
                      ? ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: Text("Confirm Approval"),
                                  content: Text(
                                    "Are you sure you want to approve Dr.${widget.patient.firstName} request?",
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: AppColors.DARK_GREEN,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop(true);
                                        setState(() {
                                          isBtnClicked = true;
                                        });
                                        state.setDoctorId(
                                          widget.patient.doctorId,
                                        );

                                        final result =
                                            await DoctorNotificationController.handleApprovedPatientResponse(
                                              ref,
                                            );
                                        if (result == 200) {
                                    
                                          setState(() {
                                            isBtnClicked = false;
                                          });
                                        }
                                      },
                                      child: Text(
                                        "Approve",
                                        style: TextStyle(
                                          color: AppColors.DARK_GREEN,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.green,
                            ),
                          ),
                          child: Text(
                            "approve",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : widget.patient.status != null
                      ? Container(
                          decoration: BoxDecoration(
                            color: "${widget.patient.status}" == 'rejected'
                                ? Colors.red
                                : "${widget.patient.status}" == 'accepted'
                                ? Colors.green
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(25),
                                child: Container(
                                  color:
                                      "${widget.patient.status}" == 'rejected'
                                      ? const Color.fromARGB(255, 255, 124, 114)
                                      : "${widget.patient.status}" == 'accepted'
                                      ? const Color.fromARGB(255, 100, 189, 103)
                                      : Colors.white,
                                  width: 10.w,
                                  child:
                                      "${widget.patient.status}" == 'rejected'
                                      ? Transform.scale(
                                          scale: 0.5,
                                          child: Lottie.asset(
                                            "assets/json/OCL Canceled.json",
                                          ),
                                        )
                                      : "${widget.patient.status}" == 'accepted'
                                      ? Transform.scale(
                                          scale: 0.8,
                                          child: Lottie.asset(
                                            "assets/json/Tick Pop.json",
                                          ),
                                        )
                                      : Container(),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              "${widget.patient.status}" == 'rejected'
                                  ? Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "rejected",
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          ),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : "${widget.patient.status}" == 'accepted'
                                  ? Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "accepted",
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          ),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        )
                      : Container(),
                ),
        ],
      ),
    );
  }
}
