import 'dart:convert';

class Hospital {
  int? id;
  String? hospitalName;
  String? location;
  String? type;
  String? phoneNumber;
  String? description;
  int? workingHours;
  String? image;
  String? role;
  List<dynamic> departments;
  List<dynamic> services;

  Hospital({
    this.id,
    this.hospitalName,
    this.location,
    this.image,
    this.type,
    this.phoneNumber,
    required this.departments,
    this.description,
    this.role,
    required this.services,
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
      departments: jsonDecode(json['departments']),
      description: json['description'],
      role: json['role'],
      services: jsonDecode(json['services']),
      workingHours: json['workingHours'],
    );
  }
}
