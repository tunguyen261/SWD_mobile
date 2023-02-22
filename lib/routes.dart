import 'package:flutter/material.dart';

import './pages/home_page.dart';
import './pages/service.dart';
import './pages/cart.dart';
import './pages/profile.dart';

class Routes {
  static const String home = '/';
  static const String service = '/service';
  static const String cart = '/cart';
  static const String profile = '/profile';

  static final Map<String, WidgetBuilder> routes = {
    home: (BuildContext context) => HomePage(),
    service: (BuildContext context) => ServicePage(),
    cart: (BuildContext context) => CartPage(),
    profile: (BuildContext context) => ProfilePage(),
  };
}