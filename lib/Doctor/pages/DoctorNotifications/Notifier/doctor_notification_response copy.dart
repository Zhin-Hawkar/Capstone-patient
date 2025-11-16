import 'package:capstone/Doctor/pages/DoctorNotifications/Model/doctor_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
class DoctorNotificationResponseNotifier
    extends StateNotifier<DoctorNotificationResponse> {
  DoctorNotificationResponseNotifier() : super(DoctorNotificationResponse());

  void setPatientId(int? patientId) {
    state = state.copyWith(patientId: patientId);
  }

  void setComment(String? comment) {
    state = state.copyWith(comment: comment);
  }
}

final doctorNotificationResponseNotifierProvider =
    StateNotifierProvider<
      DoctorNotificationResponseNotifier,
      DoctorNotificationResponse
    >((ref) => DoctorNotificationResponseNotifier());
