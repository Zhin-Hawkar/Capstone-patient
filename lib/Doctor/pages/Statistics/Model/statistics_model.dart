class StatisticsModel {
  int? patients;
  int? requests;

  StatisticsModel({this.patients, this.requests});

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      patients: json['numberOfPatients'],
      requests: json['numberOfRequests'],
    );
  }
}
