import 'package:capstone/Patient/Pages/Booking/Model/send_appointment_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod(keepAlive: true)
class SendAppointmentNotifier extends StateNotifier<SendAppointmentModel> {
  SendAppointmentNotifier() : super(SendAppointmentModel());

  void setFirstName(String? firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void setLastName(String? lastName) {
    state = state.copyWith(lastName: lastName);
  }

  void setAge(int? age) {
    state = state.copyWith(age: age);
  }

  void setGender(String? gender) {
    state = state.copyWith(gender: gender);
  }

  void setEmail(String? email) {
    state = state.copyWith(email: email);
  }

  void setPhoneNumber(String? phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

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
