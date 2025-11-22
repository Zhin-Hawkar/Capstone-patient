import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:capstone/SharedResources/global_storage_service.dart';
import 'package:capstone/Constants/enum.dart';

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
        print("Pusher state: $previousState → $currentState");
      },
      onError: (message, code, exception) {
        print("Pusher error: $message ($code) $exception");
      },
      onEvent: (event) {
        print("Event received: ${event.eventName} Data: ${event.data}");

        final data = event.data;

        if (data.isNotEmpty) {
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
