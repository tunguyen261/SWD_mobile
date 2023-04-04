import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../consts/global_colors.dart';
import '../models/request_model.dart';
import 'package:http/http.dart' as http;

class RequestWidget extends StatefulWidget {
  const RequestWidget({Key? key}) : super(key: key);

  @override
  State<RequestWidget> createState() => _RequestWidgetState();
}

class _RequestWidgetState extends State<RequestWidget> {

  @override
  Widget build(BuildContext context) {

    final requestModelProvider = Provider.of<RequestModel>(context);
    Size size = MediaQuery.of(context).size;
    String _content = 'Not Found';
    switch (requestModelProvider.status) {
      case 1:
        _content = 'Pending...';
        break;
      case 2:
        _content = 'Processing...';
        break;
      case 3:
        _content = 'Complete';
        break;
      default:
        break;
    }
    Icon getIcon() {
      switch(requestModelProvider.status) {
        case 1:
          return Icon(Icons.access_time, color: Colors.orange);
        case 2:
          return Icon(Icons.query_stats_outlined, color: Colors.blue);
        case 3:
          return Icon(Icons.task_alt_outlined, color: Colors.green);
        default:
          return Icon(Icons.error, color: Colors.grey);
      }
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {

          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                            text: 'Status: ',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight:FontWeight.bold,
                                color: Color.fromRGBO(22, 216, 0, 1.0)),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "${_content}",
                                  style: TextStyle(
                                      color: lightTextColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                    ),
                    getIcon(),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  requestModelProvider.description.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize:20,
                    fontStyle: FontStyle.italic,
                    //  fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final url = Uri.parse(
                        'https://lacha.s2tek.net/api/Request/editStatus/${requestModelProvider.id}');
                    final headers = {
                      'Content-Type': 'application/json'
                    };
                    String id = requestModelProvider.id.toString();
                    final body = json.encode({
                      "status": 3,
                    });

                    final response = await http.put(url,
                        headers: headers, body: body);
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.leftSlide,
                        headerAnimationLoop: false,
                        dialogType: DialogType.success,
                        showCloseIcon: true,
                        title: 'Success Request',
                        desc:
                        'Your Request of Room(${requestModelProvider.id}) mark complete successful',
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
                        'Your Request of Room(${requestModelProvider.id}) mark complete failed',
                        btnOkOnPress: () {},
                        btnOkIcon: Icons.cancel,
                        btnOkColor: Colors.red,
                      ).show();
                    }
                  },
                  child: const Text("Mark As Complete Request"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

