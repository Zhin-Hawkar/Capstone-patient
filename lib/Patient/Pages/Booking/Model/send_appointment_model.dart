class SendAppointmentModel {
  String? firstName;
  String? lastName;
  int? age;
  String? gender;
  String? email;
  String? department;
  String? phoneNumber;
  String? help;
  DateTime? date_time;
  String? medical_record;

  SendAppointmentModel({
    this.firstName,
    this.lastName,
    this.age,
    this.gender,
    this.phoneNumber,
    this.email,
    this.department,
    this.help,
    this.date_time,
    this.medical_record,
  });

  SendAppointmentModel copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    int? age,
    String? gender,
    String? email,
    String? department,
    String? help,
    DateTime? date_time,
    String? medical_record,
  }) {
    return SendAppointmentModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      department: department ?? this.department,
      help: help ?? this.help,
      date_time: date_time ?? this.date_time,
      medical_record: medical_record ?? this.medical_record,
    );
  }
}
