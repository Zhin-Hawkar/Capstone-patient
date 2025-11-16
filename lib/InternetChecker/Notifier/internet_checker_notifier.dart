import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'internet_checker_notifier.g.dart';

@riverpod
class InternetCheckerNotifier extends _$InternetCheckerNotifier {
  @override
  bool build() => false;

  void setConnection(bool isConnected) {
    state = isConnected;
  }

  bool isConnected() {
    return state;
  }
}
