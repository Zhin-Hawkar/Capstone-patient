import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Controller/doctor_notification.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Model/doctor_notification.dart';
import 'package:capstone/Patient/Pages/Notifications/Controller/patient_notification.dart';
import 'package:capstone/Reusables/AppBar/app_bar.dart';
import 'package:capstone/Reusables/Buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: notifications.length,
                              itemBuilder: (context, index) {
                                return Dismissible(
                                  key: Key("${notifications[index].firstName}"),
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
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                                  child: ListTile(
                                    leading: ClipRRect(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(25),
                                      child: notifications[index].image == null
                                          ? Icon(Icons.person)
                                          : Image.network(
                                              "${notifications[index].image}",
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 1.h),
                                        Text(
                                          '${notifications[index].department}',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        SizedBox(width: 18.w, child: Divider()),
                                        Text(
                                          '${notifications[index].gender}',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    title: Text(
                                      "${notifications[index].firstName} ${notifications[index].lastName}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    trailing: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            "${notifications[index].status}" ==
                                                'pending'
                                            ? Colors.amber
                                            : "${notifications[index].status}" ==
                                                  'rejected'
                                            ? Colors.red
                                            : "${notifications[index].status}" ==
                                                  'accepted'
                                            ? Colors.green
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),

                                      width: 27.w,
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  25,
                                                ),
                                            child: Container(
                                              color:
                                                  "${notifications[index].status}" ==
                                                      'pending'
                                                  ? const Color.fromARGB(
                                                      255,
                                                      255,
                                                      219,
                                                      111,
                                                    )
                                                  : "${notifications[index].status}" ==
                                                        'rejected'
                                                  ? const Color.fromARGB(
                                                      255,
                                                      255,
                                                      124,
                                                      114,
                                                    )
                                                  : "${notifications[index].status}" ==
                                                        'accepted'
                                                  ? const Color.fromARGB(
                                                      255,
                                                      100,
                                                      189,
                                                      103,
                                                    )
                                                  : Colors.white,
                                              width: 10.w,
                                              child:
                                                  "${notifications[index].status}" ==
                                                      'pending'
                                                  ? Transform.scale(
                                                      scale: 0.9,
                                                      child: Lottie.asset(
                                                        "assets/json/clock time.json",
                                                      ),
                                                    )
                                                  : "${notifications[index].status}" ==
                                                        'rejected'
                                                  ? Transform.scale(
                                                      scale: 0.5,
                                                      child: Lottie.asset(
                                                        "assets/json/OCL Canceled.json",
                                                      ),
                                                    )
                                                  : "${notifications[index].status}" ==
                                                        'accepted'
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
                                          "${notifications[index].status}" ==
                                                  'pending'
                                              ? Text(
                                                  "Pending",
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
                                                      255,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : "${notifications[index].status}" ==
                                                    'rejected'
                                              ? Text(
                                                  "Rejected",
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
                                                      255,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : "${notifications[index].status}" ==
                                                    'accepted'
                                              ? Text(
                                                  "Accepted",
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
                                                      255,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
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
