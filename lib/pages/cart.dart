import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView(
        children: [
          Card(
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(
                      'https://cdn.pixabay.com/photo/2015/02/24/15/41/dog-647528__480.jpg'),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Price: \$50'),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.remove),
                            ),
                            Text('1'),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(
                      'https://cdn.pixabay.com/photo/2015/02/24/15/41/dog-647528__480.jpg'),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Price: \$50'),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.remove),
                            ),
                            Text('1'),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1, color:Colors.black38),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \$100',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            MaterialButton(
              onPressed: () {},
              child: Text(
                'Checkout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}