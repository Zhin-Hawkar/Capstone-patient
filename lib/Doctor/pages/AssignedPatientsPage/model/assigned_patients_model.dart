class AssignedPatientsModel {
  int? patientId;
  int? doctorId;
  String? firstName;
  String? lastName;
  String? doctorFirstName;
  String? doctorLastName;
  String? hospitalName;
  String? hospitalLocation;
  String? doctorImage;
  int? age;
  String? gender;
  String? email;
  String? department;
  String? help;
  String? medical_record;
  DateTime? date_time;
  String? status;
  String? image;

  AssignedPatientsModel({
    this.patientId,
    this.doctorId,
    this.firstName,
    this.lastName,
    this.doctorFirstName,
    this.doctorLastName,
    this.hospitalLocation,
    this.doctorImage,
    this.age,
    this.hospitalName,
    this.gender,
    this.email,
    this.department,
    this.help,
    this.medical_record,
    this.date_time,
    this.status,
    this.image,
  });

  factory AssignedPatientsModel.frommJson(Map<String, dynamic> json) {
    return AssignedPatientsModel(
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      doctorFirstName: json['doctorFirstName'],
      doctorLastName: json['doctorLastName'],
      age: json['age'],
      gender: json['gender'],
      email: json['email'],
      hospitalName: json['hospitalName'],
      doctorImage: json['doctorImage'],
      hospitalLocation: json['hospitalLocation'],
      department: json['department'],
      help: json['help'],
      medical_record: json['medical_record'],
      date_time: DateTime.parse(json['date_time']),
      status: json['status'],
      image: json['image'],
    );
  }
}


