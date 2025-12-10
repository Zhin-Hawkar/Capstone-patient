import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Doctor/pages/AssignedPatientsPage/model/assigned_patients_model.dart';

class AssignedPatientsController {
  static Future<dynamic> handleAcceptedAppointments() async {
    Map<String, dynamic> results = await _showAcceptedAppointments();
    List<dynamic> result = results["notification"];
    List<AssignedPatientsModel> appointments = result
        .map((e) => AssignedPatientsModel.frommJson(e))
        .toList();
    return appointments;
  }

  static _showAcceptedAppointments() async {
    final result = await HttpUtil().post("api/showdoctoracceptedappointments");
    return result;
  }
}
