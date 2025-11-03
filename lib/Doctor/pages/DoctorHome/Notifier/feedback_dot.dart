import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'feedback_dot.g.dart';


@riverpod
class FeedbackDot extends _$FeedbackDot {
  @override
  int build() => 0;

   void incrementIndex(int index) {
    state = index;
  }
}
