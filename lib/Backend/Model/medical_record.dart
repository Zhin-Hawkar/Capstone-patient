class MedicalRecord {
  int? id;
  String? fileName;
  String? medicalRecord;

  MedicalRecord({this.id, this.fileName, this.medicalRecord});

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'],
      fileName: json['fileName'],
      medicalRecord: json['medicalRecord'],
    );
  }

  MedicalRecord copyWith({String? fileName, String? medicalRecord}) {
    return MedicalRecord(
      fileName: fileName ?? this.fileName,
      medicalRecord: medicalRecord ?? this.medicalRecord,
    );
  }
}
