import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:garden_app/pages/profile.dart';

class HelpPage extends StatelessWidget {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  HelpPage({Key? key, this.pickedFile}) : super(key: key);
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

  Future<void> selectFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ProfilePage(pickedFile: result.files.first)));
  }

  Future uploadFile() async {
    final path = 'filesMB/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            if (pickedFile != null)
              Expanded(
                child: Container(
                  color: Colors.blue[50],
                  child: Image.file(
                    File(pickedFile!.path!),
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              padding: const EdgeInsets.all(10),
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onPressed: () => selectFile(context),
              child: const Text(
                'Choose file.. ',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              padding: const EdgeInsets.all(10),
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onPressed: uploadFile,
              child: const Text(
                'Upload',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
