class MedicalRecord {
  int? id;
  String? fileName;
  String? medicalRecord;
  String? privacy;

  MedicalRecord({this.id, this.fileName, this.medicalRecord, this.privacy});

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'],
      fileName: json['fileName'],
      medicalRecord: json['medicalRecord'],
      privacy: json['privacy'],
    );
  }

  MedicalRecord copyWith({String? fileName, String? medicalRecord}) {
    return MedicalRecord(
      fileName: fileName ?? this.fileName,
      medicalRecord: medicalRecord ?? this.medicalRecord,
    );
  }
}

class MedicalDocument {
  int? patientId;
  String? fileName;
  String? medicalRecord;

  MedicalDocument({this.patientId, this.fileName, this.medicalRecord});

  factory MedicalDocument.fromJson(Map<String, dynamic> json) {
    return MedicalDocument(
      patientId: json['patientId'],
      fileName: json['fileName'],
      medicalRecord: json['medicalRecord'],
    );
  }

  MedicalDocument copyWith({
    int? patientId,
    String? fileName,
    String? medicalRecord,
  }) {
    return MedicalDocument(
      patientId: patientId ?? this.patientId,
      fileName: fileName ?? this.fileName,
      medicalRecord: medicalRecord ?? this.medicalRecord,
    );
  }
}
