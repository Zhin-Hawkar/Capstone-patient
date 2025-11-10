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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    final result = await showAppointments();
    setState(() {
      appointments = result;
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
      drawer: CustomDrawer(),
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
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(25),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 1.h),
                              Text(
                                '${appointments[index].department}',
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(width: 18.w, child: Divider()),
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
                                  "${appointments[index].status}" == 'pending'
                                  ? Colors.amber
                                  : "${appointments[index].status}" ==
                                        'rejected'
                                  ? Colors.red
                                  : "${appointments[index].status}" ==
                                        'accepted'
                                  ? Colors.green
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),

                            width: 27.w,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(
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
                                "${appointments[index].status}" == 'pending'
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
                                    : "${appointments[index].status}" ==
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
                                    : "${appointments[index].status}" ==
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
