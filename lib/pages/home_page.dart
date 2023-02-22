import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomePage extends StatelessWidget {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  void setupFirebaseMessaging(BuildContext context) {
    messaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message.notification?.title ?? 'New Notification'),
          content: Text(message.notification?.body ?? 'Body'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LachaGaden"),
        backgroundColor: Colors.green,
      ),
    );
  }
}
