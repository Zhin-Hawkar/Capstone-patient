import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:capstone/SharedResources/global_storage_service.dart';
import 'package:capstone/Constants/enum.dart';

class NotificationService {
  static final PusherChannelsFlutter _pusher =
      PusherChannelsFlutter.getInstance();

  static Future<void> init(BuildContext context) async {
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(event.data.toString())));
      },
    );

    await _pusher.connect();
    await _pusher.subscribe(channelName: "doctor");
  }

  static Future<void> disconnect() async {
    await _pusher.unsubscribe(
      channelName:
          "doctor",
    );
    await _pusher.disconnect();
  }
}
