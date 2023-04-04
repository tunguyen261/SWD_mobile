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
import 'package:awesome_dialog/awesome_dialog.dart';

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
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    int status = 1;
    return SingleChildScrollView(
      child: Column(
        children: controller.cartProducts.asMap().entries.map((entry) {
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
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                        onPressed: controller.isEmptyCart
                            ? null
                            : () {
                                AwesomeDialog(
                                  context: context,
                                  keyboardAware: true,
                                  dismissOnBackKeyPress: false,
                                  dialogType: DialogType.warning,
                                  animType: AnimType.bottomSlide,
                                  btnCancelText: "Cancel Order",
                                  btnOkText: "Yes, I will pay",
                                  title: 'Continue to pay?',
                                  // padding: const EdgeInsets.all(5.0),
                                  desc:
                                      'Please confirm that you will pay ${product.price} Dollar to booking this garden.',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    print("PackageID: ${product.id}" +
                                        " RoomID: ${_selectedItem?.id}" +
                                        " Time: ${now.toLocal().toString()}");
                                    final url = Uri.parse(
                                        'https://lacha.s2tek.net/api/Garden/create');
                                    final headers = {
                                      'Content-Type': 'application/json'
                                    };
                                    final body = json.encode({
                                      "dateTime": formattedDate,
                                      "gardenPackageId": product.id,
                                      "roomId": _selectedItem?.id
                                    });

                                    final response = await http.post(url,
                                        headers: headers, body: body);

                                    if (response.statusCode == 200 ||
                                        response.statusCode == 201) {
                                      print('Post request sent successfully');
                                      AwesomeDialog(
                                        context: context,
                                        animType: AnimType.leftSlide,
                                        headerAnimationLoop: false,
                                        dialogType: DialogType.success,
                                        showCloseIcon: true,
                                        title: 'Success Booking',
                                        desc:
                                            'Your Room: ${_selectedItem?.roomNumber} booking garden: ${product.title} successful',
                                        btnOkOnPress: () {
                                          debugPrint('OnClick');
                                        },
                                        btnOkIcon: Icons.check_circle,
                                        onDismissCallback: (type) {
                                          debugPrint(
                                              'Dialog Dismiss from callback $type');
                                        },
                                      ).show();
                                      setState(() {
                                        controller.cartProducts.removeAt(index);
                                      });
                                    } else {
                                      print(
                                          'Error sending post request: ${response.statusCode}');
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        animType: AnimType.rightSlide,
                                        headerAnimationLoop: false,
                                        title: 'Error Booking',
                                        desc:
                                            'Your Room: ${_selectedItem?.roomNumber} can not booking garden: ${product.title}',
                                        btnOkOnPress: () {},
                                        btnOkIcon: Icons.cancel,
                                        btnOkColor: Colors.red,
                                      ).show();
                                    }
                                  },
                                ).show();
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
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                Colors.white,
                Colors.yellow.shade500,
                Colors.white,
                Colors.yellow.shade500
              ],
            ).createShader(bounds);
          },
          child: Text(
            'My Cart',
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
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
