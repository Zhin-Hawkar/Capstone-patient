import 'package:capstone/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class OnboardingPages extends StatelessWidget {
  String? title;
  String? description;
  LottieBuilder? lottie;

  OnboardingPages({super.key, this.title, this.description, this.lottie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 150),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Transform.scale(scale: 0.8, child: lottie),
          Container(
            margin: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 13.h),
            child: Text(
              textAlign: TextAlign.center,
              title.toString(),
              style: TextStyle(
                color: AppColors.DARK_GREEN,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 3.w, right: 3.w),
            child: Text(
              textAlign: TextAlign.center,
              description.toString(),
              style: TextStyle(
                color: AppColors.WHITE_TEXT,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
