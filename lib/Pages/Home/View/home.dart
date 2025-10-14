import 'package:capstone/Backend/Model/user_model.dart';
import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Pages/AiChat/View/ai_chat.dart';
import 'package:capstone/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:capstone/Pages/Search/View/search.dart';
import 'package:capstone/Reusables/AppBar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(signInNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: CustomAppBar(title: ""),
      drawer: CustomDrawer(),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: AiChat(),
              ),
            );
          },
          backgroundColor: AppColors.DARK_GREEN,
          shape: CircleBorder(),
          child: Transform.scale(
            scale: 1.2,
            child: Lottie.asset("assets/json/E V E.json"),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10.w, top: 5.h),
                  child: Text(
                    "Hello, ${profileState.profile!.firstName}!",
                    style: TextStyle(
                      color: AppColors.DARK_GREEN,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(25),
              child: Image.asset(
                "assets/img/poster/good-health-message-board-with-green-apple-stethoscope-white-background.jpg",
                width: 80.w,
                height: 20.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10.h),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 7.w),
                      child: Text(
                        "Suggested Doctors",
                        style: TextStyle(
                          color: AppColors.DARK_GREEN,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 7.w),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: SearchPage(),
                            ),
                          );
                        },
                        child: Text(
                          "see all",
                          style: TextStyle(
                            color: AppColors.DARK_GREEN,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 25.h,
                        width: 25.w,
                        child: ListView.builder(
                          itemCount: 5,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(20),
                              height: 25.h,
                              width: 60.w,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 238, 238, 238),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(25),
                                        child: Image.asset(
                                          "assets/img/doctor/${UserModel.doctors[index]['image']}",
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: 1.h,
                                              bottom: 1.h,
                                              left: 2.w,
                                            ),

                                            child: Text(
                                              UserModel.doctors[index]['name'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 2.w),

                                            child: Text(
                                              UserModel
                                                  .doctors[index]['specialty'],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 2.w),
                                            child: Text(
                                              UserModel
                                                  .doctors[index]['degree'],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    thickness: 1,
                                    indent: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 2.w,
                                      right: 2.w,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.local_hospital),
                                        Text(
                                          UserModel.doctors[index]['hospital'],
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 2.w,
                                      right: 2.w,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.pin_drop),
                                        Text(
                                          UserModel.doctors[index]['location'],
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 7.w),
                      child: Text(
                        "Suggested Hospitals",
                        style: TextStyle(
                          color: AppColors.DARK_GREEN,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 7.w),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: SearchPage(),
                            ),
                          );
                        },
                        child: Text(
                          "see all",
                          style: TextStyle(
                            color: AppColors.DARK_GREEN,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 25.h,
                        width: 25.w,
                        child: ListView.builder(
                          itemCount: 5,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(20),
                              height: 25.h,
                              width: 60.w,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 238, 238, 238),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(25),
                                        child: Image.asset(
                                          "assets/img/doctor/${UserModel.doctors[index]['image']}",
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: 1.h,
                                              bottom: 1.h,
                                              left: 2.w,
                                            ),

                                            child: Text(
                                              UserModel.doctors[index]['name'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 2.w),

                                            child: Text(
                                              UserModel
                                                  .doctors[index]['specialty'],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 2.w),
                                            child: Text(
                                              UserModel
                                                  .doctors[index]['degree'],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    thickness: 1,
                                    indent: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 2.w,
                                      right: 2.w,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.local_hospital),
                                        Text(
                                          UserModel.doctors[index]['hospital'],
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 2.w,
                                      right: 2.w,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.pin_drop),
                                        Text(
                                          UserModel.doctors[index]['location'],
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
