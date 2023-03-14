import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:garden_app/models/drop_list_model.dart';
import 'package:garden_app/models/products_model.dart';
import 'package:garden_app/services/room.dart';
import 'package:garden_app/widgets/empty_cart.dart';
import 'package:get/get.dart';
import 'package:garden_app/services/product.dart';
import '../widgets/select_drop_list.dart';
import 'package:http/http.dart' as http;

final ProductController controller = Get.put(ProductController());
final RoomController controllerRoom = Get.put(RoomController());

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  DropdownItem? _selectedItem;
  void _onDropdownItemSelected(DropdownItem? selectedItem) {
    setState(() {
      _selectedItem = selectedItem;
    });
  }

  Widget cartList() {
    DateTime now= DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    int status = 1;
    return SingleChildScrollView(
      child: Column(
        children: controller.cartProducts
            .asMap()
            .entries
            .map((entry) {
          int index = entry.key;
          ProductsModel product = entry.value;
          bool shouldRemove = false;
          return Container(
            key: ValueKey(product.id),
            width: double.infinity,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey[200]?.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.lightGreen,
                  ),
                  child: ClipRRect(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.all(0.5),
                        child: Image.network(
                          product.images!,
                          width: 140,
                          height: 130,
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      product.title.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Price: ${product.price.toString()}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 5),
                    MyDropdownMenu(onItemSelected: _onDropdownItemSelected),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(10),
                            backgroundColor: Colors.deepOrange,
                            alignment: Alignment.center),
                        onPressed: () {
                          setState(() {
                            controller.cartProducts.removeAt(index);
                          });
                        },
                        child: const Text("Remove"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(10),
                            backgroundColor: Colors.blueAccent,
                            alignment: Alignment.center),
                        onPressed: controller.isEmptyCart ? null :
                            ()async {
                            print("PackageID: ${product.id}"+" RoomID: ${_selectedItem?.id}"+ " Time: ${now.toLocal().toString()}");
                            final url = Uri.parse('https://lacha.s2tek.net/api/Garden/create');
                            final headers = {'Content-Type': 'application/json'};
                            final body = json.encode({
                              "status": 1,
                              "dateTime": formattedDate,
                              "gardenPackageId": product.id,
                              "roomId": _selectedItem?.id
                            });

                            final response = await http.post(url, headers: headers, body: body);

                            if (response.statusCode == 200 || response.statusCode == 201 ) {
                              print('Post request sent successfully');
                              AlertDialog(
                                title: Text('Delete Success'),
                                content: Text('Your item has been successfully deleted.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                              setState(() {
                                controller.cartProducts.removeAt(index);
                              });
                            } else {
                              print('Error sending post request: ${response.statusCode}');
                              AlertDialog(
                                title: Text('Delete Failed'),
                                content: Text('Your item has not been deleted.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            }
                        },
                        child: const Text("Booking Now"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("My cart"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: !controller.isEmptyCart ? cartList() : const EmptyCart(),
          ),
        ],
      ),
    );
  }
}