import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'dots_indicator_notifier.g.dart';

@riverpod
class DotsIndicatorIndex extends _$DotsIndicatorIndex {
  @override
  int build() {
    return 0;
  }

  void incrementIndex(int index) {
    state = index;
  }
}