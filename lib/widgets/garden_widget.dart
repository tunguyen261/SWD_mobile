import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:garden_app/models/products_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:garden_app/models/garden_model.dart';
import 'package:intl/intl.dart';

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
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
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
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(10.0),
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
                    desc:
                    'Dialog description here..................................................',
                    btnCancelOnPress: () {},
                    onDismissCallback: (type) {
                      debugPrint('Dialog Dismiss from callback $type');
                    },
                    btnOkOnPress: () {},
                  ).show();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow[700]!),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: Text('Cancel Order'),
              ),
              SizedBox(width: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(

                      type: PageTransitionType.fade,
                      child: GardenDetailPage(id: gardenModelProvider.id.toString()),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: Text('Detail Order'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
