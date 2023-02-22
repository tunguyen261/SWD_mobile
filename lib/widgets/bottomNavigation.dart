import 'package:flutter/material.dart';
import 'package:garden_app/routes.dart';
import '../pages/home_page.dart';
import '../pages/service.dart';
import '../pages/cart.dart';
import '../pages/profile.dart';

// ignore: must_be_immutable
class bottomNavigation extends StatelessWidget {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ServicePage(),
    CartPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index, BuildContext context) {
    Navigator.pushNamed(context, Routes.routes.keys.toList()[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Stack(
        children: [
          BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_repair_service_outlined),
                label: 'Service',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            //currentIndex: _selectedIndex,
            //onTap: (index) => _onItemTapped(index, context),
          ),
        ],
      ),
    );
  }
}
