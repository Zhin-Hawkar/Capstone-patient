import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Controller/doctor_notification.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Model/doctor_notification.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/View/notification_request_detail_page.dart';
import 'package:capstone/Reusables/AppBar/app_bar.dart';
import 'package:capstone/Reusables/Buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class DoctorNotifications extends StatefulWidget {
  const DoctorNotifications({super.key});

  @override
  State<DoctorNotifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<DoctorNotifications>
    with SingleTickerProviderStateMixin {
  late TabController _tab_controller;
  List<DoctorNotification> notifications = [];
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
    List<DoctorNotification> result = await showNotifications();
    setState(() {
      notifications = result;
    });
  }

  Future<dynamic> showNotifications() async {
    List<DoctorNotification> result =
        await DoctorNotificationController.notifyDoctor();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: CustomAppBar(title: "Notifications"),
      drawer: CustomDoctorDrawer(),
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
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child:
                                                NotificationRequestDetailPage(
                                                  detail: notifications[index],
                                                ),
                                          ),
                                        );
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
                Center(child: Text("this week")),
                Center(child: Text("earlier")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  const PatientCard({required this.patient});

  final DoctorNotification patient;

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
