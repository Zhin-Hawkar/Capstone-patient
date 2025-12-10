// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotiService {
//   final notificationPlugin = FlutterLocalNotificationsPlugin();

//   bool _isInitialized = false;
//   bool get isInitialized => _isInitialized;

//   Future<void> initNotifications() async {
//     if (_isInitialized) return;
//     const initSettingsAndroid = AndroidInitializationSettings(
//       "@mipmap/ic_launcher",
//     );
//     const initSettings = InitializationSettings(android: initSettingsAndroid);
//     await notificationPlugin.initialize(initSettings);
//   }

//   NotificationDetails notificationDetails() {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         "notification_id",
//         "Notification Id",
//         channelDescription: "Notification Id",
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//     );
//   }

//   Future<void> showNotifications({
//     int id = 0,
//     String? title,
//     String? body,
//   }) async {
//     return notificationPlugin.show(id, title, body, NotificationDetails());
//   }
// }
