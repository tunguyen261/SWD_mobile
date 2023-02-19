import 'package:flutter/material.dart';

class LoginScreen5 extends StatefulWidget {
  final String avatarImage;
  final void Function() onLoginClick;
  final void Function() googleSignIn;
  final void Function() navigatePage;
  LoginScreen5({
    required this.avatarImage,
    required this.onLoginClick,
    required this.googleSignIn,
    required this.navigatePage,
  });
  @override
  _LoginScreen5State createState() => _LoginScreen5State();
}

class _LoginScreen5State extends State<LoginScreen5> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/signin_page_background.png'), fit: BoxFit.fill),
            ),
          ),

          Container(
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 2 - 50,
              top: MediaQuery.of(context).size.height / 10.1,
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(widget.avatarImage),
            ),
          ),
        ],
      ),
    );
  }
}