import 'dart:async';
import 'package:capstone/Backend/Model/medical_record.dart';
import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Doctor/pages/AssignedPatientsPage/model/assigned_patients_model.dart';
import 'package:capstone/FileManipulation/UploadFiles/upload_files.dart';
import 'package:capstone/FileManipulation/UploadFiles/view_file.dart';
import 'package:capstone/Patient/Pages/Appointments/Controller/appointments_controller.dart';
import 'package:capstone/Patient/Pages/EditProfile/View/edit_profile.dart';
import 'package:capstone/Patient/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:capstone/Patient/Pages/UserProfile/Controller/medical_upload_controller.dart';
import 'package:capstone/Patient/Pages/UserProfile/Notifier/medical_uplaod_notifier.dart';
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
  bool isLoading = false;
  bool isDeleteLoading = false;
  List<PlatformFile> filesSaved = [];
  List<MedicalRecord> records = [];
  List<AssignedPatientsModel> acceptedAppointments = [];
  // ignore: non_constant_identifier_names
  late TabController _tab_controller;
  final PageController _pageController = PageController();
  final PageController _eidtPrivacyPageController = PageController();
  Timer time = Timer(Duration.zero, () {});

  Future<void> refresh() async {
    returnMedicalRecords();
  }

  void showPatientAcceptedAppointments() async {
    List<AssignedPatientsModel> result =
        await AppointmentController.handlePatientAcceptedAppointments();

    setState(() {
      acceptedAppointments = result;
    });
  }

  Future<void> returnMedicalRecords() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> response =
        await MedicalRecordUploadController.retrieveRecord();

    if (response['code'] == 200) {
      setState(() {
        isLoading = false;
      });
      List<dynamic> recordList = response['record'];

      records = recordList.map((json) => MedicalRecord.fromJson(json)).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _tab_controller = TabController(length: 1, vsync: this);
    returnMedicalRecords();
    showPatientAcceptedAppointments();
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
    final medicalRecord = ref.watch(medicalUplaodNotifierProvider.notifier);

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
                            profileState.profile?.age != 0
                                ? Text(
                                    "${profileState.profile?.age ?? 0}",
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
                            profileState.profile?.location != "null"
                                ? Text(
                                    profileState.profile?.location ?? "null",
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
                profileState.profile?.description != "null"
                    ? ReadMoreText(
                        profileState.profile?.description ?? "null",
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
                isLoading
                    ? Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : records.isEmpty
                    ? Center(child: Text("No files uploaded"))
                    : RefreshIndicator(
                        onRefresh: refresh,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                          scrollDirection: Axis.vertical,
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onLongPress: () {
                                          showModalBottomSheet(
                                            showDragHandle: true,
                                            backgroundColor:
                                                AppColors.WHITE_BACKGROUND,
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                builder: (context, setModalState2) {
                                                  return SizedBox(
                                                    height: 25.h,
                                                    width: MediaQuery.of(
                                                      context,
                                                    ).size.width,
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 150,
                                                            child: PageView(
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              controller:
                                                                  _eidtPrivacyPageController,
                                                              children: [
                                                                ListTile(
                                                                  leading: Icon(
                                                                    Icons.edit,
                                                                    color:
                                                                        const Color.fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0,
                                                                        ),
                                                                  ),
                                                                  title: Text(
                                                                    "Edit privacy",
                                                                  ),
                                                                  onTap: () {
                                                                    _eidtPrivacyPageController.nextPage(
                                                                      duration: Duration(
                                                                        milliseconds:
                                                                            300,
                                                                      ),
                                                                      curve: Curves
                                                                          .easeInCirc,
                                                                    );
                                                                  },
                                                                ),
                                                                SingleChildScrollView(
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          IconButton(
                                                                            onPressed: () {
                                                                              _eidtPrivacyPageController.animateToPage(
                                                                                0,
                                                                                duration: Duration(
                                                                                  milliseconds: 300,
                                                                                ),
                                                                                curve: Curves.easeInCirc,
                                                                              );
                                                                            },
                                                                            icon: Icon(
                                                                              Icons.arrow_back,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),

                                                                      ListView.builder(
                                                                        shrinkWrap:
                                                                            true,
                                                                        physics:
                                                                            NeverScrollableScrollPhysics(),
                                                                        itemCount:
                                                                            acceptedAppointments.length,
                                                                        itemBuilder:
                                                                            (
                                                                              context,
                                                                              i,
                                                                            ) {
                                                                              final doctor = acceptedAppointments[i];

                                                                              return ListTile(
                                                                                leading: Icon(
                                                                                  Icons.person,
                                                                                ),
                                                                                title: Text(
                                                                                  "${doctor.doctorFirstName}",
                                                                                ),
                                                                                trailing: Switch(
                                                                                  value:
                                                                                      records[index].privacy ==
                                                                                      "public",
                                                                                  onChanged:
                                                                                      (
                                                                                        newValue,
                                                                                      ) async {
                                                                                        String privacy = newValue
                                                                                            ? "public"
                                                                                            : "private";
                                                                                        setModalState2(
                                                                                          () {
                                                                                            records[index].privacy = privacy;
                                                                                          },
                                                                                        );

                                                                                        final result = await MedicalRecordUploadController.editPrivacy(
                                                                                          id: records[index].id,
                                                                                          url: records[index].medicalRecord,
                                                                                          fileName: records[index].fileName,
                                                                                          privacy: privacy,
                                                                                          doctorId: doctor.doctorId,
                                                                                        );

                                                                                        if (result ==
                                                                                            200) {
                                                                                          Navigator.pop(
                                                                                            // ignore: use_build_context_synchronously
                                                                                            context,
                                                                                          );
                                                                                          refresh();
                                                                                        }
                                                                                      },
                                                                                ),
                                                                              );
                                                                            },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          ListTile(
                                                            leading: Icon(
                                                              Icons.delete,
                                                              color: Colors.red,
                                                            ),
                                                            title: Text(
                                                              "Delete record",
                                                            ),
                                                            onTap: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (
                                                                      BuildContext
                                                                      context,
                                                                    ) {
                                                                      return isDeleteLoading
                                                                          ? CircularProgressIndicator()
                                                                          : AlertDialog(
                                                                              title: Text(
                                                                                "Confirm Delete",
                                                                              ),
                                                                              content: Text(
                                                                                "are you sure you want to delete ${records[index].fileName}?",
                                                                              ),
                                                                              actions:
                                                                                  <
                                                                                    Widget
                                                                                  >[
                                                                                    TextButton(
                                                                                      onPressed: () =>
                                                                                          Navigator.of(
                                                                                            context,
                                                                                          ).pop(
                                                                                            false,
                                                                                          ),
                                                                                      child: Text(
                                                                                        "CANCEL",
                                                                                        style: TextStyle(
                                                                                          color: AppColors.DARK_GREEN,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    TextButton(
                                                                                      onPressed: () async {
                                                                                        setState(
                                                                                          () {
                                                                                            isDeleteLoading = true;
                                                                                          },
                                                                                        );
                                                                                        final result = await MedicalRecordUploadController.deleteRecord(
                                                                                          id: int.parse(
                                                                                            records[index].id.toString(),
                                                                                          ),
                                                                                        );
                                                                                        if (result['code'] ==
                                                                                            200) {
                                                                                          Navigator.of(
                                                                                            // ignore: use_build_context_synchronously
                                                                                            context,
                                                                                          ).pop(
                                                                                            true,
                                                                                          );
                                                                                          Navigator.of(
                                                                                            // ignore: use_build_context_synchronously
                                                                                            context,
                                                                                          ).pop(
                                                                                            true,
                                                                                          );
                                                                                          refresh();
                                                                                          setState(
                                                                                            () {
                                                                                              isDeleteLoading = false;
                                                                                            },
                                                                                          );
                                                                                        }
                                                                                      },
                                                                                      child: Text(
                                                                                        "DELETE",
                                                                                        style: TextStyle(
                                                                                          color: Colors.red,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                            );
                                                                    },
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.fade,
                                              child: FileViewer(
                                                pdfUrl: records[index]
                                                    .medicalRecord
                                                    .toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.DARK_GREEN,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          width: 120,
                                          height: 120,
                                          child: Stack(
                                            children: [
                                              records[index].privacy ==
                                                      "private"
                                                  ? Container(
                                                      margin: EdgeInsets.only(
                                                        top: 10,
                                                        right: 10,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                            Icons.lock,
                                                            color: AppColors
                                                                .WHITE_BACKGROUND,
                                                            size: 25,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.file_copy,
                                                        color: AppColors
                                                            .WHITE_BACKGROUND,
                                                        size: 60,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "${records[index].fileName}",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
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
                                        medicalRecord.setFileName(
                                          filesSaved[i].name,
                                        );
                                        medicalRecord.setMedicalRecord(
                                          filesSaved[i].path!,
                                        );
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
                                        onPressed: () async {
                                          _pageController.nextPage(
                                            duration: Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.easeInCirc,
                                          );
                                          await MedicalRecordUploadController.uploadMedicalRecord(
                                            ref,
                                          );
                                          setModalState(() {
                                            filesSaved.clear();
                                          });
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
                                  refresh();
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
