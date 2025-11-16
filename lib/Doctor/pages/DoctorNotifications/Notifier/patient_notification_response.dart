import 'package:capstone/Doctor/pages/DoctorNotifications/Model/doctor_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
class PatientNotificationResponseNotifier
    extends StateNotifier<PatientNotificationResponse> {
  PatientNotificationResponseNotifier() : super(PatientNotificationResponse());

  void setDoctorId(int? doctorId) {
    state = state.copyWith(doctorId: doctorId);
  }
}

final patientNotificationResponseNotifierProvider =
    StateNotifierProvider<
      PatientNotificationResponseNotifier,
      PatientNotificationResponse
    >((ref) => PatientNotificationResponseNotifier());
