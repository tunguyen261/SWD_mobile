import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:garden_app/pages/edit_profile.dart';
import 'package:garden_app/pages/help_page.dart';
import 'package:garden_app/pages/room_owner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:garden_app/auth_service.dart';
import 'package:page_transition/page_transition.dart';

class ProfilePage extends StatelessWidget {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  ProfilePage({Key? key, this.pickedFile}) : super(key: key);
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
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      FirebaseAuth.instance.currentUser!.photoURL!),
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
                    SizedBox(
                      height: 8,
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () {
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
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: EditProfilePage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.add_chart),
                  title: const Text('Order Info'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: EditProfilePage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.roofing_rounded),
                  title: const Text('Room Owner'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: RoomOwnerPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: HelpPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Logout'),
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      headerAnimationLoop: false,
                      animType: AnimType.topSlide,
                      showCloseIcon: true,
                      closeIcon: const Icon(Icons.close_fullscreen_outlined),
                      title: 'Warning',
                      desc: 'Log Out Now ? ',
                      btnCancelOnPress: () {},
                      onDismissCallback: (type) {
                        debugPrint('Dialog Dismiss from callback $type');
                      },
                      btnOkOnPress: () {
                        AuthService().signOut();
                      },
                    ).show();
                  },
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
