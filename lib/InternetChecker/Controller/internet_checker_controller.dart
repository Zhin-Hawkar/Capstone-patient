import 'dart:async';

import 'package:capstone/InternetChecker/Notifier/internet_checker_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetCheckerController {
  static StreamSubscription? _internetConnectionStreamSubscription;
  static late ProviderContainer ref;
  static void establishChecking() {
    ref = ProviderContainer();
    _internetConnectionStreamSubscription = InternetConnection().onStatusChange
        .listen((event) {
          switch (event) {
            case InternetStatus.connected:
              ref
                  .read(internetCheckerNotifierProvider.notifier)
                  .setConnection(true);
              break;
            case InternetStatus.disconnected:
              ref
                  .read(internetCheckerNotifierProvider.notifier)
                  .setConnection(false);
              break;
          }
        });
  }
}
