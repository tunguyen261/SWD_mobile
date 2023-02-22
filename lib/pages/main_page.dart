import 'package:flutter/material.dart';
import 'package:garden_app/pages/profile.dart';
import 'package:garden_app/pages/cart.dart';
import 'package:garden_app/pages/home_page.dart';
import 'package:garden_app/pages/service.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _UserMainState();
}

class _UserMainState extends State<MainPage> {
  int currentTab = 0;
  final List<Widget> screens = [
     HomePage(),
     CartPage(),
     ServicePage(),
     ProfilePage(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen =  HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.tealAccent,
      //   splashColor: Colors.amberAccent,
      //   onPressed: () {},
      //   elevation: 0,
      //   child: const Icon(Icons.add),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen =  HomePage();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: currentTab == 0 ? Colors.green : Colors.grey,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                              color:
                              currentTab == 0 ? Colors.green : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen =  CartPage();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          color: currentTab == 1 ? Colors.green : Colors.grey,
                        ),
                        Text(
                          'Cart',
                          style: TextStyle(
                              color:
                              currentTab == 1 ? Colors.green : Colors.grey),
                        )
                      ],
                    ),
                  )
                ],
              ),
              // Right Tab Bar Icons
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = ServicePage();
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_repair_service_rounded,
                          color: currentTab == 2 ? Colors.green : Colors.grey,
                        ),
                        Text(
                          'Service',
                          style: TextStyle(
                              color:
                              currentTab == 2 ? Colors.green : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = ProfilePage();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: currentTab == 3 ? Colors.green : Colors.grey,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                              color:
                              currentTab == 3 ? Colors.green : Colors.grey),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}