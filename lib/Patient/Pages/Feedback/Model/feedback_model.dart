class FeedbackModel {
  int? hospitalId;
  int? rating;
  String? comment;

  FeedbackModel({this.hospitalId, this.rating, this.comment});

  FeedbackModel copyWith({int? hospitalId, int? rating, String? comment}) {
    return FeedbackModel(
      hospitalId: hospitalId ?? this.hospitalId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
    );
  }
}

class FeedbackResponseModel {
  int? hospitalId;
  int? rating;
  String? feedback;
  String? patientName;
  String? hospitalName;
  String? hospitalLocation;
  String? hospitalImage;

  FeedbackResponseModel({
    this.hospitalId,
    this.rating,
    this.feedback,
    this.hospitalImage,
    this.hospitalLocation,
    this.hospitalName,
    this.patientName,
  });

  factory FeedbackResponseModel.fromJson(Map<String, dynamic> json) {
    return FeedbackResponseModel(
      hospitalId: json['hospitalId'],
      rating: json['rating'],
      feedback: json['feedback'],
      patientName: json['patientName'],
      hospitalName: json['hospitalName'],
      hospitalLocation: json['hospitalLocation'],
      hospitalImage: json['hospitalImage'],
    );
  }
}
