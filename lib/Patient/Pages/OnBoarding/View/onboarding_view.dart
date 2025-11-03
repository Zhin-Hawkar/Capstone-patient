import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Constants/enum.dart';
import 'package:capstone/Patient/Pages/Home/View/home.dart';
import 'package:capstone/Patient/Pages/LogIn/View/login_page.dart';
import 'package:capstone/Patient/Pages/OnBoarding/Notifier/dots_indicator_notifier.dart';
import 'package:capstone/Reusables/Buttons/buttons.dart';
import 'package:capstone/Reusables/Widgets/reusable_widgets.dart';
import 'package:capstone/SharedResources/global_storage_service.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class OnBoardingPage extends ConsumerStatefulWidget {
  const OnBoardingPage({super.key});

  @override
  ConsumerState<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends ConsumerState<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 0);
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.only(
                  topLeft: Radius.elliptical(160, 80),
                  topRight: Radius.elliptical(160, 80),
                ),
                child: Container(height: 36.h, color: AppColors.DARK_GREEN),
              ),
            ],
          ),
          PageView(
            onPageChanged: (value) {
              ref
                  .watch(dotsIndicatorIndexProvider.notifier)
                  .incrementIndex(value);
            },
            controller: controller,
            children: [
              OnboardingPages(
                title: "Access Global Healthcare, Right from Iraq",
                description:
                    "Our platform connects patients in Iraq with trusted international doctors and hospitals. If treatment isn’t available locally, we help you find the right specialists abroad, safely and reliably.",
                lottie: Lottie.asset("assets/json/Medical Location.json"),
              ),
              OnboardingPages(
                title: "Trusted & Verified Medical Institutions",
                description:
                    "We ensure all listed hospitals and doctors are verified and trustworthy. Patients can search by specialty, compare options, and avoid misinformation.",
                lottie: Lottie.asset("assets/json/doctors.json"),
              ),
              OnboardingPages(
                title: "24/7 \n AI Guidance",
                description:
                    "From analyzing medical reports to providing visa guidance, our AI assistant helps you every step of the way.",
                lottie: Lottie.asset("assets/json/E V E.json"),
              ),
              OnboardingPages(
                title: "Safe. Simple. \n Stress Free.",
                description:
                    "Easily book appointments, and share medical records. Our app ensures privacy, transparency, and reliability, so you can focus on your health, not the process.",
                lottie: Lottie.asset("assets/json/Medical Shield.json"),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DotsIndicator(
                          position: ref
                              .read(dotsIndicatorIndexProvider)
                              .toDouble(),
                          dotsCount: 4,
                          animate: true,
                          decorator: DotsDecorator(
                            activeSize: Size(17, 17),
                            spacing: EdgeInsets.all(10),
                            color: AppColors.WHITE_TEXT,
                            activeColor: AppColors.DOTS_ACTIVE,
                            activeShape: BeveledRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadiusGeometry.horizontal(
                                left: Radius.circular(20),
                                right: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      margin: EdgeInsets.only(right: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ref.watch(dotsIndicatorIndexProvider) == 3
                              ? OnboardingButton(
                                  buttonText: "Start",
                                  function: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => Home(),
                                      ),
                                    );
                                    GlobalStorageService.storageService.setBool(
                                      EnumValues.DEVICE_FIRST_OPEN,
                                      true,
                                    );
                                  },
                                )
                              : OnboardingButton(
                                  buttonText: "Next",
                                  function: () {
                                    controller.nextPage(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInCirc,
                                    );
                                  },
                                ),
                        ],
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
