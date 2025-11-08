import 'dart:convert';

import 'package:capstone/Backend/PusherSocket/pusher_notification.dart';
import 'package:capstone/Constants/enum.dart';
import 'package:capstone/Doctor/pages/DoctorNotifications/Controller/doctor_notification.dart';
import 'package:capstone/Reusables/AppBar/app_bar.dart';
import 'package:capstone/SharedResources/global_storage_service.dart';
import 'package:flutter/material.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _HomePageState();
}

class _HomePageState extends State<DoctorHome> {
  List<dynamic> _notifications = [];

  @override
  void initState() {
    super.initState();
    setupSocket();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final result = await retrieveNotification();
    setState(() {
      _notifications = result['notification'];
    });
  }

  Future<dynamic> retrieveNotification() async {
    final result = await DoctorNotificationController.notifyDoctor();
    return result;
  }

  void setupSocket() {
    NotificationService.init(context, channelName: "doctor");
  }

  @override
  void dispose() {
    NotificationService.disconnect(channelName: "doctor");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Dashboard')),
      drawer: CustomDrawer(),
      body: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(
              "${_notifications[index]['firstName']} ${_notifications[index]['lastName']}",
            ),
            subtitle: Text(_notifications[index]['department']),
            trailing: Text(_notifications[index]['date_time']),
          );
        },
      ),
    );
  }
}
