import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:garden_app/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,

      // body: Container(
      //   width: size.width,
      //   height: size.height,
      //   padding: EdgeInsets.only(
      //       left: 20,
      //       right: 20,
      //       top: size.height * 0.2,
      //       bottom: size.height * 0.5),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       const Text("Hello \nWelcome to LaChaGarden",
      //           style: TextStyle(
      //             fontSize: 30,
      //             color: Colors.green,
      //           )),
      //       TextButton(
      //         onPressed: () {
      //           AuthService().signInWithGoogle();
      //         },
      //         child: Text('Login with Gooogle'),
      //         //child: const Image(width: 100, image: AssetImage('assets/google.png'))
      //       ),
      //     ],
      //   ),
      // ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Welcome To LaChaGarden',
                  style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.green),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50.0),
                Image.asset('assets/images/logo1.jpg'),
                const SizedBox(height: 50.0),
                ElevatedButton(
                  onPressed: () {
                    AuthService().signInWithGoogle();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.g_mobiledata_rounded),
                      const SizedBox(width: 12.0),
                      Text(
                        'Sign in with Google',
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
