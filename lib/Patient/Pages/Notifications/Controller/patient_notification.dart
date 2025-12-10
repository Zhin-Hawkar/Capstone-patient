import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Model/doctor_notification.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Notifier/patient_notification_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientNotificationController {
  static Future<dynamic> notifyPatient() async {
    Map<String, dynamic> notifications = await _sendPatientNotifyRequest();
    List<dynamic> result = notifications['notification'];
    List<DoctorNotification> appointments = result
        .map((e) => DoctorNotification.frommJson(e))
        .toList();
    return appointments;
  }

  static Future<dynamic> handleApprovedPatientResponse(WidgetRef ref) async {
    final state = ref.watch(patientNotificationResponseNotifierProvider);
    PatientNotificationResponse response = PatientNotificationResponse()
      ..doctorId = state.doctorId;
    Map<String, dynamic> notifications = await _sendApprovedPatientResponse(
      response: response,
    );
    final result = notifications['code'];
    return result;
  }

   static _sendApprovedPatientResponse({
    PatientNotificationResponse? response,
  }) async {
    var result = await HttpUtil().post(
      "api/acceptdoctorrequest",
      data: {"doctorId": response?.doctorId},
    );
    return result;
  }

  static _sendPatientNotifyRequest() async {
    var result = await HttpUtil().get("api/senddoctornotification");
    return result;
  }
}
