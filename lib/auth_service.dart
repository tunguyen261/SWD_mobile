

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:garden_app/pages/home_page.dart';
import 'package:garden_app/pages/login_register_page.dart';
import 'package:google_sign_in/google_sign_in.dart';



class AuthService{
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return const LoginPage();
          }
        });
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: <String>["email"]).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,

    );
    print("tokenUS: ${googleAuth.idToken}");
    // Once signed in, return the UserCredential

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //Sign out
  signOut() async{
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();

  }

}