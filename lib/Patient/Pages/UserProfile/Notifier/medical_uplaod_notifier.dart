import 'package:capstone/Backend/Model/medical_record.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
class MedicalUplaodNotifier extends StateNotifier<MedicalRecord> {
  MedicalUplaodNotifier() : super(MedicalRecord());

  void setFileName(String fileName) {
    state = state.copyWith(fileName: fileName);
  }

  void setMedicalRecord(String medicalRecord) {
    state = state.copyWith(medicalRecord: medicalRecord);
  }
}

final medicalUplaodNotifierProvider =
    StateNotifierProvider<MedicalUplaodNotifier, MedicalRecord>(
      (ref) => MedicalUplaodNotifier(),
    );
