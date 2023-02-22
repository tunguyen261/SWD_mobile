import 'package:flutter/material.dart';
import 'package:garden_app/widgets/bottomNavigation.dart';

class ServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Text("service"),
    );
  }
}
