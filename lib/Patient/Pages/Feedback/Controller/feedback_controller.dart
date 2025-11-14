import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Doctor/pages/DoctorHome/Notifier/feedback_dot.dart';
import 'package:capstone/Patient/Pages/Feedback/Model/feedback_model.dart';
import 'package:capstone/Patient/Pages/Feedback/Notifier/feedback_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedbackController {
  static Future<dynamic> handleFeedback(WidgetRef ref) async {
    final state = ref.watch(feedbackNotifierProvider);
    FeedbackModel feedback = FeedbackModel()
      ..hospitalId = state.hospitalId
      ..rating = state.rating
      ..comment = state.comment;
    print(feedback.comment);
    print(feedback.rating);
    print(feedback.hospitalId);
    final result = await _sendFeedback(feedback: feedback);
    print(result);
    return result["code"];
  }

  static Future<dynamic> showAllFeedbacks() async {
    List<dynamic> result = await _getAllFeedbacks();
    List<FeedbackResponseModel> feedbacks = result
        .map((e) => FeedbackResponseModel.fromJson(e))
        .toList();
    final reversedFeedbacks = feedbacks.reversed.toList();
    return reversedFeedbacks;
  }

  static Future<dynamic> _sendFeedback({FeedbackModel? feedback}) async {
    final result = await HttpUtil().post(
      "api/addfeedback",
      data: {
        "hospitalId": feedback?.hospitalId,
        "rating": feedback?.rating,
        "feedback": feedback?.comment,
      },
    );
    return result;
  }

  static Future<dynamic> _getAllFeedbacks() async {
    final result = await HttpUtil().get("api/getallfeedbacks");
    return result["feedbacks"];
  }
}
