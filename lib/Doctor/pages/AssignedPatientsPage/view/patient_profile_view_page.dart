import 'package:capstone/Backend/Model/medical_record.dart';
import 'package:capstone/Constants/colors.dart';
import 'package:capstone/Doctor/pages/AssignedPatientsPage/model/assigned_patients_model.dart';
import 'package:capstone/FileManipulation/UploadFiles/view_file.dart';
import 'package:capstone/Patient/Pages/UserProfile/Controller/medical_upload_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class PatientProfileViewPage extends StatelessWidget {
  AssignedPatientsModel patient;
  PatientProfileViewPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Patient Profile View'),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.search)),
          SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          _PatientHeader(patient: patient),
          SizedBox(height: 20),
          _MedicalRecords(patientId: patient.patientId),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _PatientHeader extends StatelessWidget {
  AssignedPatientsModel patient;
  _PatientHeader({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          patient.image != null
              ? ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: Image.network(
                      "${patient.image}",
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: Icon(Icons.person_2),
                  ),
                ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${patient.firstName} ${patient.lastName}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text('Age: ${patient.age}'),
                SizedBox(height: 6),
                Text('Gender: ${patient.gender}'),
                SizedBox(height: 6),
                Text('Email: ${patient.email}'),
                SizedBox(height: 6),
                Text(
                  'Doctor: Dr. ${patient.doctorFirstName} ${patient.doctorLastName}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _MedicalRecords extends StatefulWidget {
  int? patientId;
  _MedicalRecords({required this.patientId});

  @override
  State<_MedicalRecords> createState() => _MedicalRecordsState();
}

class _MedicalRecordsState extends State<_MedicalRecords>
    with SingleTickerProviderStateMixin {
  bool isUploaded = false;

  bool isLoading = false;

  bool isDeleteLoading = false;

  List<PlatformFile> filesSaved = [];

  List<MedicalRecord> records = [];

  // ignore: non_constant_identifier_names
  late TabController _tab_controller;
  Future<void> refresh() async {
    returnMedicalRecords();
  }

  Future<void> returnMedicalRecords() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> response =
        await MedicalRecordUploadController.retrieveRecordsToDoctor(
          patientId: widget.patientId,
        );

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
  }

  @override
  void dispose() {
    _tab_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                              height: 15.h,
                                              width: MediaQuery.of(
                                                context,
                                              ).size.width,
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                title: Text("delete record"),
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return isDeleteLoading
                                                          ? CircularProgressIndicator()
                                                          : AlertDialog(
                                                              title: Text(
                                                                "Confirm Delete",
                                                              ),
                                                              content: Text(
                                                                "are you sure you want to delete ${records[index].fileName}?",
                                                              ),
                                                              actions: <Widget>[
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
                                                                      color: AppColors
                                                                          .DARK_GREEN,
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () async {
                                                                    setState(() {
                                                                      isDeleteLoading =
                                                                          true;
                                                                    });
                                                                    final result = await MedicalRecordUploadController.deleteRecord(
                                                                      id: int.parse(
                                                                        records[index]
                                                                            .id
                                                                            .toString(),
                                                                      ),
                                                                    );
                                                                    if (result['code'] ==
                                                                        200) {
                                                                      Navigator.of(
                                                                        context,
                                                                      ).pop(
                                                                        true,
                                                                      );
                                                                      Navigator.of(
                                                                        context,
                                                                      ).pop(
                                                                        true,
                                                                      );
                                                                      refresh();
                                                                      setState(() {
                                                                        isDeleteLoading =
                                                                            false;
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    "DELETE",
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                    },
                                                  );
                                                },
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
                                          pdfUrl: records[index].medicalRecord
                                              .toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.DARK_GREEN,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    width: 120,
                                    height: 120,
                                    child: Icon(
                                      Icons.file_copy,
                                      color: AppColors.WHITE_BACKGROUND,
                                      size: 60,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text("${records[index].fileName}"),
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
    );
  }
}
