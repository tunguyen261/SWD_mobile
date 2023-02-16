import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getFcmToken() async {
  String? fcmKey = await FirebaseMessaging.instance.getToken();
  return fcmKey;
}