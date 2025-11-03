import 'dart:async';
import 'package:capstone/Backend/Model/user_model.dart';
import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Constants/enum.dart';
import 'package:capstone/FileManipulation/UploadFiles/upload_files.dart';
import 'package:capstone/Patient/Pages/EditProfile/View/edit_profile.dart';
import 'package:capstone/Patient/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:capstone/Reusables/Buttons/buttons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

class DoctorProfile extends ConsumerStatefulWidget {
  const DoctorProfile({super.key});

  @override
  ConsumerState<DoctorProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<DoctorProfile>
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
    _tab_controller = TabController(length: 1, vsync: this);
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(right: 5.w),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: EditProfile(),
                      ),
                    );
                  },
                  child: Text(
                    "edit",
                    style: TextStyle(fontSize: 18, color: AppColors.DARK_GREEN),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 0.h),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(25),
                  child:
                      profileState.profile?.image == null ||
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
                  "${profileState.profile?.firstName} ${profileState.profile?.lastName}",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text("${profileState.profile?.email}"),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            margin: EdgeInsets.only(left: 4.w, right: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.DARK_GREEN,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10.w),
                        child: Row(
                          children: [
                            Text(
                              "age: ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            profileState.profile!.age != 0
                                ? Text(
                                    "${profileState.profile!.age}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  )
                                : Text("___"),
                          ],
                        ),
                      ),
                      VerticalDivider(color: Colors.white, thickness: 1),
                      Container(
                        margin: EdgeInsets.only(right: 10.w),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 30,
                              color: Colors.white,
                            ),
                            profileState.profile!.location != "null"
                                ? Text(
                                    "${profileState.profile!.location}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  )
                                : Text("___"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 5.h),
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
          Divider(),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tab_controller,
              children: [
                filesSaved.isEmpty
                    ? Center(child: Text("No files uploaded"))
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        scrollDirection: Axis.vertical,
                        itemCount: filesSaved.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  width: 120,
                                  height: 120,
                                  child: Icon(Icons.file_copy, size: 80),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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
                                      setState(() => {});
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
