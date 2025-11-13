class Hospital {
  String? id;
  String? hospitalName;
  String? location;
  String? type;
  String? phoneNumber;
  String? description;
  int? workingHours;
  String? image;
  String? role;
  Map<String, dynamic>? departments;
  Map<String, dynamic>? services;

  Hospital({
    this.id,
    this.hospitalName,
    this.location,
    this.image,
    this.type,
    this.phoneNumber,
    this.departments,
    this.description,
    this.role,
    this.services,
    this.workingHours,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'],
      hospitalName: json['hospitalName'],
      location: json['location'],
      image: json['image'],
      type: json['type'],
      phoneNumber: json['phoneNumber'],
      departments: json['departments'],
      description: json['description'],
      role: json['role'],
      services: json['services'],
      workingHours: json['workingHours'],
    );
  }
}
