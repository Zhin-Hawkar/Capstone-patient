import 'package:capstone/Backend/Model/user_model.dart';
import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Reusables/AppBar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: CustomAppBar(title: "Appointments"),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: UserModel.doctors.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: UserModel.doctors.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(UserModel.doctors[index]['name']),
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
                                '${UserModel.doctors[index]['name']} dismissed',
                              ),
                            ),
                          );
                          setState(() {
                            UserModel.doctors.removeAt(index);
                          });
                        },
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm Delete"),
                                content: Text(
                                  "Are you sure you want to delete ${UserModel.doctors[index]['name']}?",
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
                            child: Image.asset(
                              "assets/img/doctor/${UserModel.doctors[index]['image']}",
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
                                UserModel.doctors[index]['specialty'],
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(width: 18.w, child: Divider()),
                              Text(
                                UserModel.doctors[index]['degree'],
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          title: Text(
                            UserModel.doctors[index]['name'],
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(
                              color:
                                  UserModel.doctors[index]['response'] ==
                                      'pending'
                                  ? Colors.amber
                                  : UserModel.doctors[index]['response'] ==
                                        'rejected'
                                  ? Colors.red
                                  : UserModel.doctors[index]['response'] ==
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
                                        UserModel.doctors[index]['response'] ==
                                            'pending'
                                        ? const Color.fromARGB(
                                            255,
                                            255,
                                            219,
                                            111,
                                          )
                                        : UserModel
                                                  .doctors[index]['response'] ==
                                              'rejected'
                                        ? const Color.fromARGB(
                                            255,
                                            255,
                                            124,
                                            114,
                                          )
                                        : UserModel
                                                  .doctors[index]['response'] ==
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
                                        UserModel.doctors[index]['response'] ==
                                            'pending'
                                        ? Transform.scale(
                                            scale: 0.9,
                                            child: Lottie.asset(
                                              "assets/json/clock time.json",
                                            ),
                                          )
                                        : UserModel
                                                  .doctors[index]['response'] ==
                                              'rejected'
                                        ? Transform.scale(
                                            scale: 0.5,
                                            child: Lottie.asset(
                                              "assets/json/OCL Canceled.json",
                                            ),
                                          )
                                        : UserModel
                                                  .doctors[index]['response'] ==
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
                                UserModel.doctors[index]['response'] ==
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
                                    : UserModel.doctors[index]['response'] ==
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
                                    : UserModel.doctors[index]['response'] ==
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
                      scale: 0.8 ,
                      child: Lottie.asset("assets/json/no data found.json"),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
