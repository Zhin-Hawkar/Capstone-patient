import 'package:capstone/Backend/Model/user_model.dart';
import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Doctor/pages/AssignedPatientsPage/controller/assigned_patients_controller.dart';
import 'package:capstone/Doctor/pages/AssignedPatientsPage/model/assigned_patients_model.dart';
import 'package:capstone/Patient/Pages/Appointments/Controller/appointments_controller.dart';
import 'package:capstone/Reusables/AppBar/app_bar.dart';
import 'package:capstone/Reusables/Buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments>
    with SingleTickerProviderStateMixin {
  List<AssignedPatientsModel> appointments = [];
  List<AssignedPatientsModel> acceptedAppointments = [];
  late TabController _tab_controller;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tab_controller = TabController(length: 2, vsync: this);

    showAppointments();
    showPatientAcceptedAppointments();
  }

  Future<void> refresh() async {
    showAppointments();
    showPatientAcceptedAppointments();
  }

  void showAppointments() async {
    setState(() {
      isLoading = true;
    });
    List<AssignedPatientsModel> result =
        await AppointmentController.handleAppointments();

    setState(() {
      appointments = result;
      isLoading = false;
    });
  }

  void showPatientAcceptedAppointments() async {
    setState(() {
      isLoading = true;
    });
    List<AssignedPatientsModel> result =
        await AppointmentController.handlePatientAcceptedAppointments();

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
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TabBarAppointmentsViewButtonOne(
                  tabController: _tab_controller,
                  buttonText: "Requested appointments",
                  function: () {
                    setState(() {
                      _tab_controller.animateTo(0);
                    });
                  },
                ),
                TabBarAppointmentsViewButtonTwo(
                  tabController: _tab_controller,
                  buttonText: "Accepted appointments",
                  function: () {
                    setState(() {
                      _tab_controller.animateTo(1);
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tab_controller,
              children: [
                Column(
                  children: [
                    Expanded(
                      child: appointments.isNotEmpty
                          ? RefreshIndicator(
                              onRefresh: () {
                                return refresh();
                              },
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: appointments.length,
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    key: Key(
                                      "${appointments[index].firstName}",
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
                                        child: appointments[index].image == null
                                            ? Icon(Icons.person)
                                            : Image.network(
                                                "${appointments[index].image}",
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
                                            '${appointments[index].department}',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(
                                            width: 18.w,
                                            child: Divider(),
                                          ),
                                          Text(
                                            '${appointments[index].gender}',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      title: Text(
                                        "${appointments[index].doctorFirstName} ${appointments[index].doctorLastName}",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      trailing: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              "${appointments[index].status}" ==
                                                  'pending'
                                              ? Colors.amber
                                              : "${appointments[index].status}" ==
                                                    'rejected'
                                              ? Colors.red
                                              : "${appointments[index].status}" ==
                                                    'accepted'
                                              ? Colors.green
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
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
                                                    "${appointments[index].status}" ==
                                                        'pending'
                                                    ? const Color.fromARGB(
                                                        255,
                                                        255,
                                                        219,
                                                        111,
                                                      )
                                                    : "${appointments[index].status}" ==
                                                          'rejected'
                                                    ? const Color.fromARGB(
                                                        255,
                                                        255,
                                                        124,
                                                        114,
                                                      )
                                                    : "${appointments[index].status}" ==
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
                                                    "${appointments[index].status}" ==
                                                        'pending'
                                                    ? Transform.scale(
                                                        scale: 0.9,
                                                        child: Lottie.asset(
                                                          "assets/json/clock time.json",
                                                        ),
                                                      )
                                                    : "${appointments[index].status}" ==
                                                          'rejected'
                                                    ? Transform.scale(
                                                        scale: 0.5,
                                                        child: Lottie.asset(
                                                          "assets/json/OCL Canceled.json",
                                                        ),
                                                      )
                                                    : "${appointments[index].status}" ==
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
                                            "${appointments[index].status}" ==
                                                    'pending'
                                                ? Text(
                                                    "Pending",
                                                    style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            0,
                                                            0,
                                                            0,
                                                          ),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                : "${appointments[index].status}" ==
                                                      'rejected'
                                                ? Text(
                                                    "Rejected",
                                                    style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            0,
                                                            0,
                                                            0,
                                                          ),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                : "${appointments[index].status}" ==
                                                      'accepted'
                                                ? Text(
                                                    "Accepted",
                                                    style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            0,
                                                            0,
                                                            0,
                                                          ),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                : Container(),
                                          ],
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
                Column(
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
                                      "${acceptedAppointments[index].firstName}",
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
                                        child:
                                            acceptedAppointments[index].image ==
                                                null
                                            ? Icon(Icons.person)
                                            : Image.network(
                                                "${acceptedAppointments[index].image}",
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
                                            '${acceptedAppointments[index].department}',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(
                                            width: 18.w,
                                            child: Divider(),
                                          ),
                                          Text(
                                            '${acceptedAppointments[index].gender}',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      title: Text(
                                        "${acceptedAppointments[index].doctorFirstName} ${acceptedAppointments[index].doctorLastName}",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      trailing: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              "${acceptedAppointments[index].status}" ==
                                                  'accepted'
                                              ? Colors.green
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
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
                                                    "${acceptedAppointments[index].status}" ==
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
                                                    "${acceptedAppointments[index].status}" ==
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
                                            "${acceptedAppointments[index].status}" ==
                                                    'accepted'
                                                ? Text(
                                                    "Accepted",
                                                    style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            0,
                                                            0,
                                                            0,
                                                          ),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                : Container(),
                                          ],
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
