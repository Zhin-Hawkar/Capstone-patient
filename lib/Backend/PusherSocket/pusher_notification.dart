import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class NotificationService {
  static final PusherChannelsFlutter _pusher =
      PusherChannelsFlutter.getInstance();

  static Future<dynamic> init(
    BuildContext context, {
    String? channelName,
  }) async {
    await _pusher.init(
      apiKey: "116c3f6587071defa627",
      cluster: "mt1",
      onConnectionStateChange: (currentState, previousState) {
      },
      onError: (message, code, exception) {
      },
      onEvent: (event) {

        final data = event.data;

        if (data.isNotEmpty) {
          // NotiService().showNotifications(
          //   title: "New notification",
          //   body: "you have new notification",
          // );
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("New notification")));
        }
      },
    );

    await _pusher.connect();
    await _pusher.subscribe(channelName: channelName.toString());
  }

  static Future<void> disconnect({String? channelName}) async {
    await _pusher.unsubscribe(channelName: channelName.toString());
    await _pusher.disconnect();
  }
}
