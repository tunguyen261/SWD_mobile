import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_model.dart';


class EditProfilePage extends StatefulWidget {

  const EditProfilePage({Key? key}) : super(key: key);
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late UserProfile _user;
  late File _image;

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  Future<void> _getUserProfile() async {
    final User? user = FirebaseAuth.instance!.currentUser!;
    final DocumentSnapshot userProfileDoc =

    await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    setState(() {
      _user = UserProfile(
        uid: user.uid,
        displayName: user.displayName!,
        email: user.email!,
        photoUrl: user.photoURL!
      );
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    //final PickedFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<String> _uploadImageToFirebaseStorage() async {
    final Reference storageReference = _storage.ref().child(
        'profile_images/${_user.uid}');
    final UploadTask uploadTask = storageReference.putFile(_image);
    final TaskSnapshot downloadUrl = await uploadTask!.whenComplete(() => {});
    final String url = await downloadUrl.ref.getDownloadURL();
    return url;
  }

  Future<void> _updateUserProfile() async {
    await _auth.currentUser!.updatePhotoURL(_image.path);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Profile updated!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  // GestureDetector(
                  //   onTap: () => _pickImage(),
                  //   child: CircleAvatar(
                  //     radius: 80,
                  //     backgroundImage: _image != null
                  //         ? FileImage(_image)!
                  //         : NetworkImage(_user.photoUrl)! as ImageProvider<Object>?,
                  //
                  //   ),
                  // ),
                  SizedBox(height: 20),
                  Text(_user.email, style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      hintText: _user.displayName,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _user.displayName = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () => _updateUserProfile(),
                    child: Text('Update'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}