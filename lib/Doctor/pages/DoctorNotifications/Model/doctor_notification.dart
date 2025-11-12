class DoctorNotification {
  String? firstName;
  String? lastName;
  int? age;
  int? yearsOfExperience;
  String? gender;
  String? description;
  String? hospital;
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
    this.age,
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
      firstName: json['firstName'],
      lastName: json['lastName'],
      age: json['age'],
      gender: json['gender'],
      description: json['description'],
      hospital: json['hospital'],
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