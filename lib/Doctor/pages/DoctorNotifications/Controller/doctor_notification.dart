import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Model/doctor_notification.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Notifier/doctor_notification_response%20copy.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Notifier/patient_notification_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoctorNotificationController {
  static Future<dynamic> notifyDoctor() async {
    Map<String, dynamic> notifications = await _sendDoctorNotifyRequest();
    List<dynamic> result = notifications['notification'];
    List<DoctorNotification> appointments = result
        .map((e) => DoctorNotification.frommJson(e))
        .toList();
    return appointments;
  }

  static Future<dynamic> handleApprovedDoctorResponse(WidgetRef ref) async {
    final state = ref.watch(doctorNotificationResponseNotifierProvider);
    DoctorNotificationResponse response = DoctorNotificationResponse()
      ..patientId = state.patientId
      ..comment = state.comment;
    print("Approving:");
    print(response.patientId);
    print(response.comment);
    Map<String, dynamic> notifications = await _sendApprovedDoctorResponse(
      response: response,
    );
    final result = notifications['code'];
    return result;
  }

  static Future<dynamic> handleRejectedDoctorResponse(WidgetRef ref) async {
    final state = ref.watch(doctorNotificationResponseNotifierProvider);
    DoctorNotificationResponse response = DoctorNotificationResponse()
      ..patientId = state.patientId
      ..comment = state.comment;
    print("Rejecting:");
    print(response.patientId);
    print(response.comment);
    Map<String, dynamic> notifications = await _sendRejectedDoctorResponse(
      response: response,
    );
    final result = notifications['code'];
    print(result);
    return result;
  }


  static _sendDoctorNotifyRequest() async {
    var result = await HttpUtil().get("api/sendpatientnotification");
    return result;
  }

  static _sendApprovedDoctorResponse({
    DoctorNotificationResponse? response,
  }) async {
    var result = await HttpUtil().post(
      "api/acceptpatientrequest",
      data: {"patientId": response?.patientId, "comment": response?.comment},
    );
    return result;
  }


  static _sendRejectedDoctorResponse({
    DoctorNotificationResponse? response,
  }) async {
    var result = await HttpUtil().post(
      "api/rejectpatientrequest",
      data: {"patientId": response?.patientId, "comment": response?.comment},
    );
    return result;
  }
}
