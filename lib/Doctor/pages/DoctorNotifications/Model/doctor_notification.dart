class DoctorNotification {
  String? firstName;
  String? lastName;
  int? age;
  int? patientId;
  int? doctorId;
  int? yearsOfExperience;
  String? gender;
  String? description;
  String? doctorImage;
  String? hospital;
  String? help;
  String? aiAnalysis;
  String? specialization;
  String? comment;
  Map<String, dynamic>? qualification;
  String? email;
  String? department;
  DateTime? date_time;
  String? status;
  String? image;

  DoctorNotification({
    this.firstName,
    this.lastName,
    this.patientId,
    this.doctorId,
    this.age,
    this.help,
    this.aiAnalysis,
    this.doctorImage,
    this.description,
    this.hospital,
    this.specialization,
    this.comment,
    this.qualification,
    this.gender,
    this.email,
    this.department,
    this.date_time,
    this.status,
    this.image,
  });

  factory DoctorNotification.frommJson(Map<String, dynamic> json) {
    return DoctorNotification(
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      age: json['age'],
      gender: json['gender'],
      description: json['description'],
      hospital: json['hospital'],
      doctorImage: json['doctorImage'],
      help: json['help'],
      aiAnalysis: json['ai_analysis'],
      specialization: json['specialization'],
      comment: json['comment'],
      qualification: json['qualification'],
      email: json['email'],
      department: json['department'],
      date_time: DateTime.parse(json['date_time']),
      status: json['status'],
      image: json['image'],
    );
  }
}

class DoctorNotificationResponse {
  String? comment;
  int? patientId;

  DoctorNotificationResponse({this.comment, this.patientId});

  DoctorNotificationResponse copyWith({String? comment, int? patientId}) {
    return DoctorNotificationResponse(
      comment: comment ?? this.comment,
      patientId: patientId ?? this.patientId,
    );
  }
}

class PatientNotificationResponse {
  int? doctorId;

  PatientNotificationResponse({this.doctorId});

  PatientNotificationResponse copyWith({String? comment, int? doctorId}) {
    return PatientNotificationResponse(
      doctorId: doctorId ?? this.doctorId,
    );
  }
}
