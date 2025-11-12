import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Doctor/pages/AssignedPatientsPage/model/assigned_patients_model.dart';

class AppointmentController {
  static Future<dynamic> handlePatientAcceptedAppointments() async {
    Map<String, dynamic> results = await _showPatientAcceptedAppointments();

    List<dynamic> result = results["notification"];
    List<AssignedPatientsModel> appointments = result
        .map((e) => AssignedPatientsModel.frommJson(e))
        .toList();
    print("Accepted patient appointments ${appointments}");
    return appointments;
  }

  static Future<dynamic> handleAppointments() async {
    Map<String, dynamic> results = await _showAppointments();

    List<dynamic> result = results["notification"];
    List<AssignedPatientsModel> appointments = result
        .map((e) => AssignedPatientsModel.frommJson(e))
        .toList();
    print("requested appointments ${appointments}");
    return appointments;
  }

  static _showAppointments() async {
    final result = await HttpUtil().post("api/showappointments");
    return result;
  }

  static _showPatientAcceptedAppointments() async {
    final patientAcceptedAppointments = await HttpUtil().post(
      "api/showpatientacceptedappointments",
    );
    return patientAcceptedAppointments;
  }
}
