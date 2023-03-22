import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:garden_app/models/products_model.dart';
import 'package:garden_app/pages/request_history.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:garden_app/models/garden_model.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../pages/garden_detail.dart';

class GardenWidget extends StatefulWidget {
  const GardenWidget({Key? key}) : super(key: key);

  @override
  _GardenWidgetState createState() => _GardenWidgetState();
}

class _GardenWidgetState extends State<GardenWidget> {
  late GardenModel gardenModel;
  late ProductsModel productsModel;

  Future<void> getGardenPackID() async {}
  @override
  void initState() {
    super.initState();
    gardenModel = Provider.of<GardenModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final gardenModelProvider = Provider.of<GardenModel>(context);
    String _content = '';
    Color _textColor = Colors.black;
    Color _borderColor = Colors.grey;

    switch (gardenModel.status) {
      case 1:
        _content = 'Pending...';
        _textColor = Colors.blue;
        _borderColor = Colors.blue;
        break;
      case 2:
        _content = 'Renting';
        _textColor = Colors.green;
        _borderColor = Colors.green;
        break;
      case 3:
        _content = 'Cancel';
        _textColor = Colors.grey;
        _borderColor = Colors.grey;
        break;
      default:
        break;
    }
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(85),
        gradient: LinearGradient(
          colors: [
            Colors.green[400]!,
            Colors.yellow[700]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(31.0, 20.0, 0.0, 0.0),
            child: Text(
              "Order ID Number: ${gardenModel.id.toString()}",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Order Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(gardenModel.dateTime!))}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  "||",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    headerAnimationLoop: false,
                    animType: AnimType.topSlide,
                    showCloseIcon: true,
                    closeIcon: const Icon(Icons.close_fullscreen_outlined),
                    title: 'Warning',
                    desc: 'Are you sure to cancel this garden order?',
                    btnCancelOnPress: () {},
                    onDismissCallback: (type) {
                      debugPrint('Dialog Dismiss from callback $type');
                    },
                    btnOkOnPress: () async {
                      final url = Uri.parse(
                          'https://lacha.s2tek.net/api/Garden/editStatus/${gardenModel.id}');
                      final headers = {'Content-Type': 'application/json'};
                      final body = json.encode({"status": 3});
                      final response =
                          await http.put(url, headers: headers, body: body);
                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        print('Post request sent successfully');
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.leftSlide,
                          headerAnimationLoop: false,
                          dialogType: DialogType.success,
                          showCloseIcon: true,
                          title: 'Success',
                          desc:
                              'Your Rental Of Garden(${gardenModel.id}) Cancel Successful',
                          btnOkOnPress: () {
                            debugPrint('OnClick');
                          },
                          btnOkIcon: Icons.check_circle,
                          onDismissCallback: (type) {
                            debugPrint('Dialog Dismiss from callback $type');
                          },
                        ).show();
                        setState(() {});
                      } else {
                        print(
                            'Error sending post request: ${response.statusCode}');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          headerAnimationLoop: false,
                          title: 'Error',
                          desc:
                              'Your Rental Of Garden(${gardenModel.id}) Cancel Fail Or Already Canceled!',
                          btnOkOnPress: () {},
                          btnOkIcon: Icons.cancel,
                          btnOkColor: Colors.red,
                        ).show();
                      }
                      ;
                    },
                  ).show();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.yellow[700]!),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: Text('Cancel Order'),
              ),
              SizedBox(width: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: GardenDetailPage(
                          id: gardenModelProvider.id.toString()),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green[400]!),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: Text('Detail Order'),
              ),
              SizedBox(width: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child:
                          RequestHistory(id: gardenModelProvider.id.toString()),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: Text('Request List'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
