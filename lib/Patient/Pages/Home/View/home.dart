import 'dart:async';

import 'package:capstone/Backend/Model/user_model.dart';
import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Patient/Pages/AiChat/View/ai_chat.dart';
import 'package:capstone/Patient/Pages/Home/Notifier/feedback_dot.dart';
import 'package:capstone/Patient/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:capstone/Patient/Pages/OnBoarding/Notifier/dots_indicator_notifier.dart';
import 'package:capstone/Patient/Pages/Search/View/search.dart';
import 'package:capstone/Reusables/AppBar/app_bar.dart';
import 'package:capstone/Reusables/Widgets/reusable_widgets.dart';
import 'package:dots_indicator/dots_indicator.dart';
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
  PageController controller = PageController(initialPage: 0);
  late Timer _timer;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 4) {
        _currentPage++;
        ref.watch(feedbackDotProvider.notifier).incrementIndex(_currentPage);
      } else {
        _currentPage = 0;
        ref.watch(feedbackDotProvider.notifier).incrementIndex(_currentPage);
      }

      controller.animateToPage(
        ref.watch(feedbackDotProvider),
        duration: Duration(milliseconds: 1500),
        curve: Curves.easeOutSine,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(signInNotifierProvider);
    final feedbackDot = ref.watch(feedbackDotProvider);
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
                  child: profileState.profile?.firstName == null
                      ? Text(
                          "Hello, Welcome!",
                          style: TextStyle(
                            color: AppColors.DARK_GREEN,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        )
                      : Text(
                          "Hello ${profileState.profile?.firstName}, Welcome!",
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
            Column(
              children: [
                SizedBox(
                  height: 250,
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (value) {
                      ref
                          .watch(feedbackDotProvider.notifier)
                          .incrementIndex(value);
                    },
                    controller: controller,
                    children: [
                      FeedbackPages(rating: 4),
                      FeedbackPages(rating: 3),
                      FeedbackPages(rating: 2),
                      FeedbackPages(rating: 1),
                      FeedbackPages(rating: 5),
                    ],
                  ),
                ),

                DotsIndicator(
                  position: feedbackDot.toDouble(),
                  dotsCount: 5,
                  animate: true,
                  animationDuration: Duration(seconds: 1),
                  axis: Axis.horizontal,
                  decorator: DotsDecorator(activeColor: AppColors.DARK_GREEN),
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
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
