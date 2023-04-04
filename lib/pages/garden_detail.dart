import 'dart:convert';
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:garden_app/pages/request_history.dart';
import 'package:garden_app/services/api_garden.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../models/garden_detail_model.dart';

class GardenDetailPage extends StatefulWidget {
  const GardenDetailPage({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<GardenDetailPage> createState() => _GardenDetailPageState();
}

class _GardenDetailPageState extends State<GardenDetailPage> {
  GardenDetailModel? gardenDetailModel;
  bool isError = false;
  String errorStr = "";
  HtmlEditorController controller = HtmlEditorController();
  TextEditingController _textFieldController = TextEditingController();
  Future<void> getGardenInfo() async {
    try {
      gardenDetailModel = await GardenAPI.getGardenById(id: widget.id);
    } catch (error) {
      isError = true;
      errorStr = error.toString();
      log("error $error");
    }
    setState(() {});
  }

  void didChangeDependencies() {
    getGardenInfo();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = const TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white);
    return Scaffold(
        body: SafeArea(
            child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green[400]!,
            Colors.yellow[700]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: isError
          ? Center(
              child: Text(
                "An error occurred $errorStr",
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            )
          : gardenDetailModel == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      const BackButton(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 18,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 4,
                                  child: Text(
                                    'ID Order Number: ${gardenDetailModel!.id}',
                                    textAlign: TextAlign.start,
                                    style: titleStyle,
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: RichText(
                                    text: TextSpan(
                                        text: '\$',
                                        style: const TextStyle(
                                            fontSize: 24,
                                            color: Color.fromRGBO(
                                                241, 190, 23, 1.0)),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: gardenDetailModel!
                                                  .gardenPackage!.price
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Room Number: ${gardenDetailModel!.room!.roomNumber}',
                                style: titleStyle),
                            const SizedBox(
                              height: 18,
                            ),
                            Text(
                                "Name Garden: ${gardenDetailModel!.gardenPackage!.namePack.toString()}",
                                style: titleStyle),
                            const SizedBox(
                              height: 18,
                            ),
                            Text(
                              "Date Booking: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(gardenDetailModel!.dateTime.toString()))}",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            // HtmlEditor(
                            //   controller: controller,
                            //   htmlEditorOptions: HtmlEditorOptions(
                            //     hint:
                            //         "Type Your Request Here For Us To Help You ...",
                            //     characterLimit: 1000,
                            //   ),
                            //   otherOptions: OtherOptions(
                            //     height: 250,
                            //   ),
                            // ),
                            TextField(
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(15, 15, 0, 100),
                                hintText: "Input your request here...",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              controller: _textFieldController,
                              // Other parameters ...
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final url = Uri.parse(
                                      'https://lacha.s2tek.net/api/Request/create');
                                  final headers = {
                                    'Content-Type': 'application/json'
                                  };
                                  String textFieldValue =
                                      await _textFieldController.text;
                                  //String data = await controller.getText();
                                  final body = json.encode({
                                    "status": 1,
                                    "description": textFieldValue,
                                    "gardenId": gardenDetailModel!.id
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
                                      title: 'Success Request',
                                      desc:
                                          'Your Request of Room(${gardenDetailModel!.room!.roomNumber}) create successful',
                                      btnOkOnPress: () {
                                        debugPrint('OnClick');
                                      },
                                      btnOkIcon: Icons.check_circle,
                                      onDismissCallback: (type) {
                                        debugPrint(
                                            'Dialog Dismiss from callback $type');
                                      },
                                    ).show();
                                  } else {
                                    print(
                                        'Error sending post request: ${response.statusCode}');
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      headerAnimationLoop: false,
                                      title: 'Error Request',
                                      desc:
                                          'Your Request of Room(${gardenDetailModel!.room!.roomNumber}) create failed',
                                      btnOkOnPress: () {},
                                      btnOkIcon: Icons.cancel,
                                      btnOkColor: Colors.red,
                                    ).show();
                                  }
                                },
                                child: const Text("Create Request"),
                              ),
                            ),
                            const SizedBox(
                              height: 275,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    )));
  }
}
