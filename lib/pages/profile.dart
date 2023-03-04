import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:garden_app/auth_service.dart';

class ProfilePage extends StatelessWidget {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  ProfilePage({Key? key, this.pickedFile}) : super(key: key);
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [

                Stack(
                  children: [

                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade200,
                      child:

                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
                      ),
                    ),
                    Positioned(
                      bottom: 0.2,
                      right: 1,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child:
                          IconButton(
                            icon: Icon(Icons.camera_alt),
                              highlightColor: Colors.lightGreen,
                              color: Colors.black,
                            onPressed: ()  {
                              selectFile(context);

                            },
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                50,
                              ),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(2, 4),
                                color: Colors.black.withOpacity(
                                  0.3,
                                ),
                                blurRadius: 3,
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(

                      FirebaseAuth.instance.currentUser!.displayName!,
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      FirebaseAuth.instance.currentUser!.email!,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8,),
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: ()  {
                        selectFile(context);
                        if (pickedFile != null) {
                          // TODO: Save the new image file
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Edit Profile'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Logout'),
                  onTap: () {AuthService().signOut();},
                ),
              ],
            ),
          ),
        ],
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       const SizedBox(
      //         height: 40,
      //       ),
      //       if (pickedFile != null)
      //         Expanded(
      //           child: Container(
      //             color: Colors.blue[50],
      //             child: Image.file(
      //               File(pickedFile!.path!),
      //               height: 100,
      //               width: double.infinity,
      //               fit: BoxFit.cover,
      //             ),
      //           ),
      //         ),
      //       const SizedBox(
      //         height: 10,
      //       ),
      //       MaterialButton(
      //         padding: const EdgeInsets.all(10),
      //         color: Colors.green,
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(5)),
      //         onPressed: () => selectFile(context),
      //         child: const Text(
      //           'Choose file.. ',
      //           style: TextStyle(color: Colors.white, fontSize: 15),
      //         ),
      //       ),
      //       const SizedBox(
      //         height: 10,
      //       ),
      //       MaterialButton(
      //         padding: const EdgeInsets.all(10),
      //         color: Colors.green,
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(5)),
      //         onPressed: uploadFile,
      //         child: const Text(
      //           'Upload',
      //           style: TextStyle(color: Colors.white, fontSize: 15),
      //         ),
      //       ),
      //       const SizedBox(
      //         height: 10,
      //       ),
      //       Text(
      //         "User: " + FirebaseAuth.instance.currentUser!.email!,
      //         style: const TextStyle(
      //             fontSize: 20,
      //             fontWeight: FontWeight.bold,
      //             color: Colors.black87),
      //       ),
      //       const SizedBox(
      //         height: 10,
      //       ),
      //       MaterialButton(
      //         padding: const EdgeInsets.all(10),
      //         color: Colors.green,
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(5)),
      //         child: const Text(
      //           'LOG OUT',
      //           style: TextStyle(color: Colors.white, fontSize: 15),
      //         ),
      //         onPressed: () {
      //           AuthService().signOut();
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
