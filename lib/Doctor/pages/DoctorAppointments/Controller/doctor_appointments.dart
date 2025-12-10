import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Doctor/pages/AssignedPatientsPage/model/assigned_patients_model.dart';

class DoctorAppointmentController {
  static Future<dynamic> handleDoctorAcceptedAppointments() async {
    Map<String, dynamic> results = await _showDoctorAcceptedAppointments();

    List<dynamic> result = results["notification"];
    List<AssignedPatientsModel> appointments = result
        .map((e) => AssignedPatientsModel.frommJson(e))
        .toList();
    return appointments;
  }

  
  static _showDoctorAcceptedAppointments() async {
    final patientAcceptedAppointments = await HttpUtil().post(
      "api/showdoctoracceptedappointments",
    );
    return patientAcceptedAppointments;
  }
}
