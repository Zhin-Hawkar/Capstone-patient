import 'package:capstone/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class OnboardingButton extends StatelessWidget {
  String? buttonText;
  Function()? function;
  OnboardingButton({super.key, this.buttonText, this.function});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          AppColors.GREEN_BUTTON_BACKGROUND,
        ),
      ),
      child: Text(
        buttonText.toString(),
        style: TextStyle(
          color: AppColors.WHITE_TEXT,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  String? buttonText;
  Color? textColor;
  Color? backgroundColor;
  Function()? function;
  CustomButton({
    super.key,
    this.buttonText,
    this.function,
    this.textColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
      ),
      child: Text(
        buttonText.toString(),
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ignore: must_be_immutable
class TabBarViewButtonOne extends StatelessWidget {
  String? buttonText;
  TabController? tabController;
  Function()? function;
  TabBarViewButtonOne({
    super.key,
    this.buttonText,
    this.function,
    this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 8.h,
        width: 31.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.DARK_GREEN),
          color: tabController!.index.isEven
              ? AppColors.DARK_GREEN
              : AppColors.WHITE_TEXT,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonText.toString(),
              style: TextStyle(
                color: tabController!.index.isEven
                    ? AppColors.WHITE_TEXT
                    : AppColors.DARK_GREEN,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TabBarViewButtonTwo extends StatelessWidget {
  String? buttonText;

  TabController? tabController;
  Function()? function;
  TabBarViewButtonTwo({
    super.key,
    this.buttonText,
    this.function,
    this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 8.h,
        width: 31.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.DARK_GREEN),
          color: tabController!.index.isOdd
              ? AppColors.DARK_GREEN
              : AppColors.WHITE_TEXT,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonText.toString(),
              style: TextStyle(
                color: tabController!.index.isOdd
                    ? AppColors.WHITE_TEXT
                    : AppColors.DARK_GREEN,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TabBarNotificationsViewButtonOne extends StatelessWidget {
  String? buttonText;
  TabController? tabController;
  Function()? function;
  TabBarNotificationsViewButtonOne({
    super.key,
    this.buttonText,
    this.function,
    this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 8.h,
        width: 31.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.DARK_GREEN),
          color: tabController!.index == 0
              ? AppColors.DARK_GREEN
              : AppColors.WHITE_TEXT,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonText.toString(),
              style: TextStyle(
                color: tabController!.index == 0
                    ? AppColors.WHITE_TEXT
                    : AppColors.DARK_GREEN,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TabBarNotificationsViewButtonTwo extends StatelessWidget {
  String? buttonText;
  double? containerWidth;
  TabController? tabController;
  Function()? function;
  TabBarNotificationsViewButtonTwo({
    super.key,
    this.buttonText,
    this.containerWidth,
    this.function,
    this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 8.h,
        width: 31.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.DARK_GREEN),
          color: tabController!.index == 1
              ? AppColors.DARK_GREEN
              : AppColors.WHITE_TEXT,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonText.toString(),
              style: TextStyle(
                color: tabController!.index == 1
                    ? AppColors.WHITE_TEXT
                    : AppColors.DARK_GREEN,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TabBarAppointmentsViewButtonOne extends StatelessWidget {
  String? buttonText;
  TabController? tabController;
  Function()? function;
  TabBarAppointmentsViewButtonOne({
    super.key,
    this.buttonText,
    this.function,
    this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 8.h,
        width: 48.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.DARK_GREEN),
          color: tabController!.index == 0
              ? AppColors.DARK_GREEN
              : AppColors.WHITE_TEXT,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonText.toString(),
              style: TextStyle(
                color: tabController!.index == 0
                    ? AppColors.WHITE_TEXT
                    : AppColors.DARK_GREEN,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TabBarAppointmentsViewButtonTwo extends StatelessWidget {
  String? buttonText;
  double? containerWidth;
  TabController? tabController;
  Function()? function;
  TabBarAppointmentsViewButtonTwo({
    super.key,
    this.buttonText,
    this.containerWidth,
    this.function,
    this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 8.h,
        width: 48.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.DARK_GREEN),
          color: tabController!.index == 1
              ? AppColors.DARK_GREEN
              : AppColors.WHITE_TEXT,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonText.toString(),
              style: TextStyle(
                color: tabController!.index == 1
                    ? AppColors.WHITE_TEXT
                    : AppColors.DARK_GREEN,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TabBarNotificationsViewButtonThree extends StatelessWidget {
  String? buttonText;
  double? containerWidth;
  TabController? tabController;
  Function()? function;
  TabBarNotificationsViewButtonThree({
    super.key,
    this.buttonText,
    this.containerWidth,
    this.function,
    this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 8.h,
        width: 31.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.DARK_GREEN),
          color: tabController!.index == 2
              ? AppColors.DARK_GREEN
              : AppColors.WHITE_TEXT,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonText.toString(),
              style: TextStyle(
                color: tabController!.index == 2
                    ? AppColors.WHITE_TEXT
                    : AppColors.DARK_GREEN,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
