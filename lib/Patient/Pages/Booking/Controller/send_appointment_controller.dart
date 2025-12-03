import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Patient/Pages/Booking/Model/send_appointment_model.dart';
import 'package:capstone/Patient/Pages/Booking/Notifier/send_appointment_notifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SendAppointmentController {
  static Future<dynamic> handleAppointment(WidgetRef ref) async {
    final state = ref.watch(sendAppointmentNotifierProvider);
    print(state.date_time);
    print(state.department);
    print(state.medical_record);
    print(state.help);
    SendAppointmentModel appointment = SendAppointmentModel()
      ..department = state.department
      ..help = state.help
      ..date_time = state.date_time
      ..medical_record = state.medical_record;
    try {
      final result = await _sendAppointment(appointment: appointment);

      return result;
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> _sendAppointment({
    SendAppointmentModel? appointment,
  }) async {
    FormData formData = FormData.fromMap({
      "department": appointment?.department,
      "help": appointment?.help,
      "date_time": appointment?.date_time?.toIso8601String(),
      "medical_record": appointment?.medical_record == null
          ? null
          : await MultipartFile.fromFile(
              appointment!.medical_record!,
              filename: appointment.medical_record!.split('/').last,
            ),
    });

    final result = await HttpUtil().post(
      "api/sendappointment",
      data: formData,
      options: Options(headers: {'Accept': 'application/json'}),
    );

    print(result);
    return result["code"];
  }
}
