import 'package:capstone/Backend/Util/http_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoctorNotificationController {
  static Future<dynamic> notifyDoctor() async {
    final notifications = await _sendDoctorNotifyRequest();
    final result = notifications['notification'];
    print(notifications);
    return notifications;
  }

  static _sendDoctorNotifyRequest() async {
    var result = await HttpUtil().get("api/sendpatientnotification");
    return result;
  }
}
