import 'package:capstone/Backend/Model/medical_record.dart';
import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Patient/Pages/UserProfile/Notifier/medical_uplaod_notifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MedicalRecordUploadController {
  static Future<dynamic> uploadMedicalRecord(WidgetRef ref) async {
    final record = ref.watch(medicalUplaodNotifierProvider);
    final medicalRecord = MedicalRecord()
      ..fileName = record.fileName
      ..medicalRecord = record.medicalRecord;
    final result = await _uploadRecord(params: medicalRecord);
    print(result);
    return result;
  }

  static Future<dynamic> retrieveRecord() async {
    final result = await HttpUtil().get("api/showmedicalrecords");
    return result;
  }

  static Future<dynamic> retrieveRecordsToDoctor({int? patientId}) async {
    final result = await HttpUtil().post(
      "api/showmedicalrecordstodoctor",
      data: {"patientId": patientId},
    );
    return result;
  }

  static Future<dynamic> _uploadRecord({MedicalRecord? params}) async {
    FormData formData = FormData.fromMap({
      "fileName": params!.medicalRecord!.split('/').last,
      if (params.medicalRecord != null && params.medicalRecord!.isNotEmpty)
        "medicalRecord": await MultipartFile.fromFile(
          params.medicalRecord!,
          filename: params.medicalRecord!.split('/').last,
        ),
    });
    final result = await HttpUtil().post(
      "api/uploadmedicalrecord",
      data: formData,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
    return result;
  }

  static Future<dynamic> deleteRecord({int? id}) async {
    FormData formData = FormData.fromMap({'id': id});
    final result = await HttpUtil().post(
      "api/deletemedicalrecord",
      data: formData,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
    print(result);
    return result;
  }
}
