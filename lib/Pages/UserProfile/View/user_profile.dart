import 'dart:async';

import 'package:capstone/Constants/colors.dart';
import 'package:capstone/FileManipulation/UploadFiles/upload_files.dart';
import 'package:capstone/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:capstone/Reusables/Buttons/buttons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 4.h),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(25),
                  child: profileState.profile!.image == null
                      ? Icon(Icons.person, size: 80)
                      : ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(25),
                          child: Image.asset(
                            profileState.profile!.image.toString(),
                            width: 40,
                            height: 50,
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

          Container(
            margin: EdgeInsets.only(top: 5.h),
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
