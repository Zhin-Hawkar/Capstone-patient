import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Constants/enum.dart';
import 'package:capstone/FileManipulation/UploadFiles/upload_files.dart';
import 'package:capstone/Pages/Home/View/home.dart';
import 'package:capstone/SharedResources/global_storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FilesUpload extends StatefulWidget {
  const FilesUpload({super.key});

  @override
  State<FilesUpload> createState() => _FilesUploadState();
}

class _FilesUploadState extends State<FilesUpload> {
  List<PlatformFile> filesSaved = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 10.h, right: 7.w, left: 7.w),
        child: Column(
          children: [
            Text(
              "Do you want to upload your medical records now?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.h),
            SizedBox(
              width: 80.w,
              height: 20.h,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.DARK_GREEN),
                  side: WidgetStatePropertyAll(BorderSide()),
                ),
                onPressed: () async {
                  List<PlatformFile>? files =
                      await UploadFiles.pickAndUploadFiles();
                  if (files != null) {
                    for (int i = 0; i < files.length; i++) {
                      setState(() {
                        filesSaved.add(files[i]);
                      });
                    }
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_file, color: Colors.white, size: 65),
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
            SizedBox(height: 10.h),
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
              margin: EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => Home()),
                      );
                      GlobalStorageService.storageService.setBool(
                        EnumValues.DEVICE_FIRST_UPLOAD,
                        true,
                      );
                    },
                    style: ButtonStyle(
                      side: WidgetStatePropertyAll(
                        BorderSide(color: AppColors.DARK_GREEN),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        AppColors.WHITE_TEXT,
                      ),
                    ),
                    child: Text(
                      "Skip",
                      style: TextStyle(color: AppColors.DARK_GREEN),
                    ),
                  ),
                  SizedBox(width: 15),
                  filesSaved.isEmpty
                      ? ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              const Color.fromARGB(69, 76, 175, 79),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "upload",
                            style: TextStyle(
                              color: const Color.fromARGB(195, 255, 255, 255),
                            ),
                          ),
                        )
                      : ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              AppColors.DARK_GREEN,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (context) => Home()),
                            );
                            GlobalStorageService.storageService.setBool(
                              EnumValues.DEVICE_FIRST_UPLOAD,
                              true,
                            );
                          },
                          child: Text(
                            "upload",
                            style: TextStyle(color: AppColors.WHITE_TEXT),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
