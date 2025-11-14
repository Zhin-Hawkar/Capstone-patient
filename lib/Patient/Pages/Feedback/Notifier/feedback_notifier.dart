import 'package:capstone/Patient/Pages/Feedback/Model/feedback_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
class FeedbackNotifier extends StateNotifier<FeedbackModel> {
  FeedbackNotifier() : super(FeedbackModel());

  void setHospitalId(int? hospitalId) {
    state = state.copyWith(hospitalId: hospitalId);
  }

  void setRating(int? rating) {
    state = state.copyWith(rating: rating);
  }

  void setComment(String? comment) {
    state = state.copyWith(comment: comment);
  }
}

final feedbackNotifierProvider =
    StateNotifierProvider<FeedbackNotifier, FeedbackModel>(
      (ref) => FeedbackNotifier(),
    );
