import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

HtmlEditorController controller = HtmlEditorController();

@override
Widget build(BuildContext context) {
  return HtmlEditor(
    controller: controller, //required
    htmlEditorOptions: HtmlEditorOptions(
      hint: "Your text here...",
      //initalText: "text content initial, if any",
    ),
    otherOptions: OtherOptions(
      height: 10,
    ),
  );
}

class ServicePage extends StatelessWidget {
  String dropdownvalue = 'Apple';

  var items = [
    'Apple',
    'Banana',
    'Grapes',
    'Orange',
    'watermelon',
    'Pineapple'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Service'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: new Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Customer: ${FirebaseAuth.instance.currentUser!.displayName!}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  DropdownButton(
                    value: "Tokyo",
                    items: [
                      DropdownMenuItem(
                          child: Text("New York"), value: "New York"),
                      DropdownMenuItem(
                          child: Text("New York"), value: "New York"),
                      DropdownMenuItem(
                          child: Text("New York"), value: "New York"),
                      DropdownMenuItem(
                          child: Text("New York"), value: "New York"),
                      DropdownMenuItem(
                        child: Text("Tokyo"),
                        value: "Tokyo",
                      )
                    ],
                    onChanged: (String? value) {},
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Service description:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 5),
                  HtmlEditor(controller: controller),
                  ElevatedButton(
                      onPressed: () async {
                        String data = await controller.getText();
                        print(data);
                      },
                      child: Text("Get HTML Text"))
                ],
              ),
            ),
          ],
        ));
  }
}
