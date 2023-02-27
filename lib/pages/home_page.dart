import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:garden_app/pages/ProductScreen.dart';

class HomePage extends StatelessWidget {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  void setupFirebaseMessaging(BuildContext context) {
    messaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message.notification?.title ?? 'New Notification'),
          content: Text(message.notification?.body ?? 'Body'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  final List<Map<String, dynamic>> products = [
    {
      'id': 'p1',
      'title': 'Garden modern',
      'description': 'Description of product 1',
      'price': 9.99,
      'imageUrl':
          'https://assets-news.housing.com/news/wp-content/uploads/2022/03/16150728/SMALL-BALCONY-GARDEN-FEATURE-compressed.jpg',
    },
    {
      'id': 'p2',
      'title': 'Garden classical',
      'description': 'Description of product 2',
      'price': 19.99,
      'imageUrl':
          'https://assets-news.housing.com/news/wp-content/uploads/2022/03/16150736/balcony-garden-7.png',
    },
    {
      'id': 'p3',
      'title': 'Garden modern 2',
      'description': 'Description of product 3',
      'price': 29.99,
      'imageUrl':
          'https://assets-news.housing.com/news/wp-content/uploads/2022/03/16150756/balcony-garden-10.png',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LachaGaden"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx, i) => Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  products[i]['imageUrl'],
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Text(
                products[i]['title'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    '\$${products[i]['price'].toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox.fromSize(
                    size: Size(40, 40),
                    child: ClipOval(
                      child: Material(
                        color: Colors.green,
                        child: InkWell(
                          splashColor: Colors.amberAccent,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                    title: products[i]['title'],
                                    imageUrl: products[i]['imageUrl'],
                                    description: products[i]['description'],
                                    price: products[i]['price']),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.shopping_cart_outlined),
                              // <-- Icon
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
