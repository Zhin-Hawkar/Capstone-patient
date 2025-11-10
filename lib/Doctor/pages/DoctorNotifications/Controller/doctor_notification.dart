import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Model/doctor_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoctorNotificationController {
  static Future<dynamic> notifyDoctor() async {
    Map<String, dynamic> notifications = await _sendDoctorNotifyRequest();
    List<dynamic> result = notifications['notification'];
    List<DoctorNotification> appointments = result
        .map((e) => DoctorNotification.frommJson(e))
        .toList();
    print(notifications);
    return appointments;
  }

  static _sendDoctorNotifyRequest() async {
    var result = await HttpUtil().get("api/senddoctornotification");
    return result;
  }
}
