import 'dart:async';

import 'package:capstone/Backend/Model/user_model.dart';
import 'package:capstone/Backend/PusherSocket/pusher_notification.dart';
import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Constants/enum.dart';
import 'package:capstone/Patient/Pages/AiChat/View/ai_chat.dart';
import 'package:capstone/Patient/Pages/Booking/View/booking_step_one.dart';
import 'package:capstone/Patient/Pages/Home/Notifier/feedback_dot.dart';
import 'package:capstone/Patient/Pages/Hospital/View/hospital_profile_page.dart';
import 'package:capstone/Patient/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:capstone/Patient/Pages/OnBoarding/Notifier/dots_indicator_notifier.dart';
import 'package:capstone/Patient/Pages/Search/View/search.dart';
import 'package:capstone/Reusables/AppBar/app_bar.dart';
import 'package:capstone/Reusables/Widgets/reusable_widgets.dart';
import 'package:capstone/SharedResources/global_storage_service.dart';
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
    if (GlobalStorageService.storageService
        .getString(EnumValues.ACCESS_TOKEN)
        .isNotEmpty) {
      setupSocket();
    }
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

  Future<void> refresh() async {}

  void setupSocket() {
    NotificationService.init(context, channelName: "doctor-notification");
  }

  @override
  void dispose() {
    if (GlobalStorageService.storageService
        .getString(EnumValues.ACCESS_TOKEN)
        .isNotEmpty) {
      NotificationService.disconnect(channelName: "doctor-notification");
    }
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
        child: RefreshIndicator(
          onRefresh: () {
            return refresh();
          },
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
              SizedBox(height: 3.h),
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
                  SizedBox(height: 2.h),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: 6,
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: HospitalProfilePage(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 238, 238, 238),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: Image.asset(
                                  UserModel.hospitals[index]['image'],
                                  height: 12.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 12.h,
                                      color: AppColors.DARK_GREEN.withOpacity(
                                        0.1,
                                      ),
                                      child: Icon(
                                        Icons.local_hospital,
                                        size: 40,
                                        color: AppColors.DARK_GREEN,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      UserModel.hospitals[index]['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      UserModel.hospitals[index]['type'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Row(
                                      children: [
                                        Icon(Icons.pin_drop, size: 14),
                                        SizedBox(width: 0.5.w),
                                        Expanded(
                                          child: Text(
                                            UserModel
                                                .hospitals[index]['location'],
                                            style: TextStyle(fontSize: 10),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Row(
                                      children: [
                                        Icon(Icons.phone, size: 14),
                                        SizedBox(width: 0.5.w),
                                        Expanded(
                                          child: Text(
                                            UserModel.hospitals[index]['phone'],
                                            style: TextStyle(fontSize: 10),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
              SizedBox(height: 5.h),
              // Booking Now Button
              Container(
                margin: EdgeInsets.symmetric(horizontal: 7.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.DARK_GREEN,
                      AppColors.DARK_GREEN.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.DARK_GREEN.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: const BookingStepOnePage(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 2.h,
                        horizontal: 5.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            "Booking Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }
}
