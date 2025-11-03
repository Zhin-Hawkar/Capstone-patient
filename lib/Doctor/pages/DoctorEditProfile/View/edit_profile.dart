import 'dart:io';
import 'package:capstone/Backend/Model/user_model.dart';
import 'package:capstone/Constants/colors.dart';
import 'package:capstone/FileManipulation/UploadFiles/upload_files.dart';
import 'package:capstone/Patient/Pages/EditProfile/Controller/edit_controller.dart';
import 'package:capstone/Patient/Pages/EditProfile/Notifier/edit_notifier.dart';
import 'package:capstone/Patient/Pages/LogIn/Notifier/sign_in_notifier.dart';
import 'package:capstone/Reusables/AppBar/app_bar.dart';
import 'package:capstone/Reusables/Buttons/buttons.dart';
import 'package:capstone/Reusables/TextFields/sign_up_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class DoctorEditProfile extends ConsumerStatefulWidget {
  const DoctorEditProfile({super.key});

  @override
  ConsumerState<DoctorEditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<DoctorEditProfile> {
  List<PlatformFile> filesSaved = [];
  File _imageFile = File("");
  bool? isEditBtnClicked = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  void _onChanged() => setState(() {});
  @override
  void initState() {
    super.initState();
    firstNameController.addListener(_onChanged);
    lastNameController.addListener(_onChanged);
    ageController.addListener(_onChanged);
    locationController.addListener(_onChanged);
    descriptionController.addListener(_onChanged);
  }

  bool get isVerified =>
      _imageFile.path != "" ||
      firstNameController.text.isNotEmpty ||
      lastNameController.text.isNotEmpty ||
      ageController.text.isNotEmpty ||
      locationController.text.isNotEmpty ||
      descriptionController.text.isNotEmpty;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(signInNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: CustomAppBarNoButton(title: "Edit"),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10.w, right: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 5.w),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 213, 213, 213),
                  borderRadius: BorderRadius.circular(70),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(70),
                      child: _imageFile.path.isEmpty
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 100,
                                  color: const Color.fromARGB(
                                    255,
                                    125,
                                    125,
                                    125,
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(
                              width: 120,
                              height: 120,
                              child: Image.file(_imageFile!, fit: BoxFit.cover),
                            ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  showDragHandle: true,
                                  backgroundColor: AppColors.WHITE_BACKGROUND,
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: 10.h,
                                      child: ListTile(
                                        title: Text("Upload image"),
                                        onTap: () async {
                                          List<PlatformFile>? files =
                                              await UploadFiles.pickAndUploadFiles();
                                          if (files != null) {
                                            for (
                                              int i = 0;
                                              i < files.length;
                                              i++
                                            ) {
                                              setState(() {
                                                _imageFile = File(
                                                  files.single.path!,
                                                );
                                              });
                                            }
                                          }
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    108,
                                    213,
                                    213,
                                    213,
                                  ),
                                  borderRadius: BorderRadius.circular(70),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: const Color.fromARGB(111, 0, 0, 0),
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
              SizedBox(height: 4.h),
              EditTextField(
                hintText: "${profileState.profile!.firstName}",
                fieldIcon: Icons.person,
                textFieldController: firstNameController,
              ),
              SizedBox(height: 3.h),
              EditTextField(
                hintText: "${profileState.profile!.lastName}",
                fieldIcon: Icons.person,
                textFieldController: lastNameController,
              ),
              SizedBox(height: 3.h),
              EditTextField(
                hintText:
                    profileState.profile!.age == 0 ||
                        profileState.profile!.age == null
                    ? "age"
                    : "${profileState.profile!.age}",
                fieldIcon: Icons.numbers,
                textFieldController: ageController,
              ),
              SizedBox(height: 3.h),
              EditTextField(
                hintText: profileState.profile!.location == "null"
                    ? "location"
                    : profileState.profile!.location,
                fieldIcon: Icons.location_on,
                textFieldController: locationController,
              ),
              SizedBox(height: 3.h),
              DescriptionTextField(
                hintText: profileState.profile!.description == "null"
                    ? "description"
                    : profileState.profile!.description,
                fieldIcon: Icons.description,
                textFieldController: descriptionController,
              ),
              SizedBox(height: 3.h),
              isEditBtnClicked == true
                  ? Transform.scale(
                      scale: 1.6,
                      child: Lottie.asset(
                        "assets/json/Material wave loading.json",
                        width: 100,
                        height: 100,
                      ),
                    )
                  : isVerified
                  ? CustomButton(
                      textColor: Colors.white,
                      backgroundColor: AppColors.DARK_GREEN,
                      buttonText: "Upload",
                      function: () async {
                        setState(() {
                          isEditBtnClicked = true;
                        });
                        ref
                            .watch(editProfileProvider.notifier)
                            .setFirstName(
                              firstNameController.text == ""
                                  ? profileState.profile!.firstName.toString()
                                  : firstNameController.text,
                            );
                        ref
                            .watch(editProfileProvider.notifier)
                            .setLastName(
                              lastNameController.text == ""
                                  ? profileState.profile!.lastName.toString()
                                  : lastNameController.text,
                            );
                        ref
                            .watch(editProfileProvider.notifier)
                            .setLocation(
                              locationController.text == ""
                                  ? profileState.profile!.location.toString()
                                  : locationController.text,
                            );
                        ref
                            .watch(editProfileProvider.notifier)
                            .setAge(
                              ageController.text == ""
                                  ? int.parse(
                                      profileState.profile!.age.toString(),
                                    )
                                  : int.parse(ageController.text),
                            );
                        ref
                            .watch(editProfileProvider.notifier)
                            .setDescription(
                              descriptionController.text == ""
                                  ? profileState.profile!.description.toString()
                                  : descriptionController.text,
                            );
                        ref
                            .watch(editProfileProvider.notifier)
                            .setImage(_imageFile?.path ?? 'null');

                        ref
                            .watch(editProfileProvider.notifier)
                            .setEmail(profileState.profile!.email.toString());
                        var result = await EditProfileController()
                            .handleProfileEdit(context, ref);

                        if (result['code'] == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color.fromARGB(
                                120,
                                0,
                                0,
                                0,
                              ),
                              content: Text(
                                "Profile updated successfully!",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            isEditBtnClicked = false;
                          });
                        }
                      },
                    )
                  : CustomButton(
                      buttonText: "Upload",
                      backgroundColor: const Color.fromARGB(255, 167, 230, 170),
                      textColor: Colors.white,
                      function: () => {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "At least one field should be changed to continue.",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
