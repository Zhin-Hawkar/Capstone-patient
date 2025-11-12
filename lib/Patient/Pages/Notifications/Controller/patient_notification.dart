import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Model/doctor_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientNotificationController {
  static Future<dynamic> notifyPatient() async {
    Map<String, dynamic> notifications = await _sendPatientNotifyRequest();
    List<dynamic> result = notifications['notification'];
    List<DoctorNotification> appointments = result
        .map((e) => DoctorNotification.frommJson(e))
        .toList();
    print(notifications);
    return appointments;
  }

  static _sendPatientNotifyRequest() async {
    var result = await HttpUtil().get("api/senddoctornotification");
    return result;
  }
}
