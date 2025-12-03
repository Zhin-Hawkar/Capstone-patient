import 'package:capstone/Patient/Pages/Booking/Model/send_appointment_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod(keepAlive: true)
class SendAppointmentNotifier extends StateNotifier<SendAppointmentModel> {
  SendAppointmentNotifier() : super(SendAppointmentModel());

  void setDepartment(String? department) {
    state = state.copyWith(department: department);
  }

  void setHelp(String? help) {
    state = state.copyWith(help: help);
  }

  void setDateTime(DateTime? date_time) {
    state = state.copyWith(date_time: date_time);
  }

  void setMedicalRecord(String? medical_record) {
    state = state.copyWith(medical_record: medical_record);
  }
}

final sendAppointmentNotifierProvider =
    StateNotifierProvider<SendAppointmentNotifier, SendAppointmentModel>(
      (ref) => SendAppointmentNotifier(),
    );
