import 'dart:async';

import 'package:capstone/Backend/Model/user_model.dart';
import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Constants/enum.dart';
import 'package:capstone/FileManipulation/UploadFiles/upload_files.dart';
import 'package:capstone/Pages/EditProfile/View/edit_profile.dart';
import 'package:capstone/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:capstone/Reusables/Buttons/buttons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key});

  @override
  ConsumerState<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile>
    with SingleTickerProviderStateMixin {
  bool isUploaded = false;
  List<PlatformFile> filesSaved = [];
  // ignore: non_constant_identifier_names
  late TabController _tab_controller;
  final PageController _pageController = PageController();
  Timer time = Timer(Duration.zero, () {});

  @override
  void initState() {
    super.initState();
    _tab_controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab_controller.dispose();
    _pageController.dispose();
    time.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(signInNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: AppBar(title: Text("Profile"), centerTitle: true),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: EditProfile(),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.DARK_GREEN,
                      borderRadius: BorderRadius.circular(20),
                    ),

                    width: 22.w,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(25),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: const Color.fromARGB(255, 159, 230, 161),
                            width: 10.w,
                            child: Transform.scale(
                              scale: 2.5,
                              child: Lottie.asset("assets/json/Crop.json"),
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "edit",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 0.h),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(25),
                  child:
                      profileState.profile!.image == null ||
                          profileState.profile!.image == "null"
                      ? Icon(Icons.person, size: 80)
                      : ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(25),
                          child: Image.network(
                            "${profileState.profile!.image}",
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${profileState.profile!.firstName} ${profileState.profile!.lastName}",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text("${profileState.profile!.email}"),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            margin: EdgeInsets.only(right: 10.w, left: 8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.DARK_GREEN,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 150, 237, 153),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          width: 20.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("age: "),
                              profileState.profile!.age != 0
                                  ? Text("${profileState.profile!.age}")
                                  : Text("___"),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.DARK_GREEN,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 150, 237, 153),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          width: 20.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on),
                              profileState.profile!.location != "null"
                                  ? Text("${profileState.profile!.location}")
                                  : Text("___"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.DARK_GREEN,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 150, 237, 153),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          width: 50.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.description),
                              Text("Description"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                profileState.profile!.description != "null"
                    ? ReadMoreText(
                        "${profileState.profile!.description}",
                        trimMode: TrimMode.Line,
                        trimLines: 2,
                        colorClickableText: AppColors.DARK_GREEN,
                        trimCollapsedText: "show more",
                        trimExpandedText: "show less",
                      )
                    : Text("___"),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 3.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TabBarViewButtonOne(
                  tabController: _tab_controller,
                  buttonText: "Medical Records",
                  function: () {
                    setState(() {
                      _tab_controller.animateTo(0);
                    });
                  },
                ),
                TabBarViewButtonTwo(
                  tabController: _tab_controller,
                  buttonText: "Doctor's Documents",
                  function: () {
                    setState(() {
                      _tab_controller.animateTo(1);
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tab_controller,
              children: [
                Center(child: Text("Medical Records")),
                Center(child: Text("Doctor's Documents")),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              showDragHandle: true,
              backgroundColor: AppColors.WHITE_BACKGROUND,
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setModalState) {
                    return PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      children: [
                        SizedBox(
                          height: 50.h,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 70.w,
                                height: 15.h,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      AppColors.DARK_GREEN,
                                    ),
                                    side: WidgetStatePropertyAll(BorderSide()),
                                  ),
                                  onPressed: () async {
                                    List<PlatformFile>? files =
                                        await UploadFiles.pickAndUploadFiles();
                                    if (files != null) {
                                      for (int i = 0; i < files.length; i++) {
                                        setModalState(() {
                                          filesSaved.add(files[i]);
                                        });
                                      }
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.upload_file,
                                        color: Colors.white,
                                        size: 65,
                                      ),
                                      Text(
                                        "Upload pdf format",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Expanded(
                                child: SizedBox(
                                  width: 50.w,
                                  height: 50.h,
                                  child: ListView.builder(
                                    itemCount: filesSaved.length,
                                    itemBuilder: (context, index) {
                                      return Text(filesSaved[index].name);
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 50),
                                child: filesSaved.isEmpty
                                    ? ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                const Color.fromARGB(
                                                  69,
                                                  76,
                                                  175,
                                                  79,
                                                ),
                                              ),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          "upload",
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                              195,
                                              255,
                                              255,
                                              255,
                                            ),
                                          ),
                                        ),
                                      )
                                    : ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                AppColors.DARK_GREEN,
                                              ),
                                        ),
                                        onPressed: () {
                                          _pageController.nextPage(
                                            duration: Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.easeInCirc,
                                          );
                                        },
                                        child: Text(
                                          "upload",
                                          style: TextStyle(
                                            color: AppColors.WHITE_TEXT,
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),

                        StatefulBuilder(
                          builder: (clockContext, setClockState) {
                            time = Timer.periodic(Duration(seconds: 2), (
                              timer,
                            ) {
                              if (clockContext.mounted) {
                                if (timer.tick == 1) {
                                  setClockState(() {
                                    isUploaded = true;
                                  });
                                } else if (timer.tick == 2) {
                                  Navigator.pop(context);
                                  time.cancel();
                                }
                              }
                            });
                            return isUploaded
                                ? Transform.scale(
                                    scale: 0.8,
                                    child: Lottie.asset(
                                      "assets/json/Done Animation.json",
                                      width: 70,
                                      height: 70,
                                    ),
                                  )
                                : Transform.scale(
                                    scale: 0.8,
                                    child: Lottie.asset(
                                      "assets/json/Material wave loading.json",
                                      width: 70,
                                      height: 70,
                                    ),
                                  );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
          backgroundColor: AppColors.DARK_GREEN,
          shape: CircleBorder(),
          child: Transform.scale(
            scale: 0.9,
            child: Lottie.asset("assets/json/Update.json"),
          ),
        ),
      ),
    );
  }
}
