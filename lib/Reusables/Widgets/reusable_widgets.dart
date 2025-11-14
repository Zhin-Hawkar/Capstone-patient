import 'package:capstone/Backend/Model/user_model.dart';
import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Patient/Pages/Feedback/Model/feedback_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
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

// ignore: must_be_immutable
class FeedbackPages extends StatefulWidget {
  FeedbackResponseModel? feedbacks;

  LottieBuilder? lottie;

  FeedbackPages({super.key, this.lottie, this.feedbacks});

  @override
  State<FeedbackPages> createState() => _FeedbackPagesState();
}

class _FeedbackPagesState extends State<FeedbackPages> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 2.w, right: 2.w),
      decoration: BoxDecoration(
        color: const Color.fromARGB(172, 236, 236, 236),
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 6.w),
                child: StarRating(
                  rating: widget.feedbacks?.rating?.toDouble() ?? 0.0,
                  starCount: 5,
                  size: 25,
                  color: Colors.amber,
                  emptyIcon: Icons.star_border,
                  filledIcon: Icons.star,
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 6.w),
                child: Icon(
                  Icons.format_quote_sharp,
                  color: AppColors.DARK_GREEN,
                  size: 60,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            margin: EdgeInsets.only(left: 6.w, right: 6.w),
            child: Text("${widget.feedbacks?.feedback}"),
          ),
          Container(
            margin: EdgeInsets.only(left: 6.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${widget.feedbacks?.patientName}, patient",
                  style: TextStyle(
                    color: const Color.fromARGB(146, 35, 35, 35),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(45),
              child: Image.network(
                "${widget.feedbacks?.hospitalImage}",
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text("${widget.feedbacks?.hospitalName}"),
            subtitle: Text("${widget.feedbacks?.hospitalLocation}"),
          ),
        ],
      ),
    );
  }
}
