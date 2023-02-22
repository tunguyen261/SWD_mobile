import 'package:flutter/material.dart';
import 'package:garden_app/widgets/bottomNavigation.dart';

class ProfilePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigation(),
    );
  }

}