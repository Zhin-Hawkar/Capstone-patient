import 'package:capstone/Backend/Model/medical_record.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
class DocumentUplaodNotifier extends StateNotifier<MedicalDocument> {
  DocumentUplaodNotifier() : super(MedicalDocument());

  void setPatientId(int patientId) {
    state = state.copyWith(patientId: patientId);
  }

  void setFileName(String fileName) {
    state = state.copyWith(fileName: fileName);
  }

  void setMedicalRecord(String medicalRecord) {
    state = state.copyWith(medicalRecord: medicalRecord);
  }
}

final documentUplaodNotifierProvider =
    StateNotifierProvider<DocumentUplaodNotifier, MedicalDocument>(
      (ref) => DocumentUplaodNotifier(),
    );
