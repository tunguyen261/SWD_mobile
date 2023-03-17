import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garden_app/models/drop_list_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyDropdownMenu extends StatefulWidget {

  final Function(DropdownItem?) onItemSelected;
  const MyDropdownMenu({required this.onItemSelected});
  @override
  _MyDropdownMenuState createState() => _MyDropdownMenuState();
}

class _MyDropdownMenuState extends State<MyDropdownMenu> {
  List<DropdownItem> _dropdownItems = [];
  DropdownItem? _selectedItem;

  @override
  void initState() {
    super.initState();
    _fetchDropdownItems();
  }

  void _fetchDropdownItems() async {

    Future<String> fetchCustomerId() async {
      String? auth= FirebaseAuth.instance.currentUser?.email;
      final response = await http.get(Uri.parse('https://lacha.s2tek.net/api/Customer/search?name=$auth'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse is List && jsonResponse.isNotEmpty) {
          final customer = jsonResponse.first;
          final id= customer["id"].toString();
          print("ID cus: ${id}");
          return id;
        }
      }

      throw Exception('Failed to fetch customer ID');
    }
    final customerId = await fetchCustomerId();
    final response =
    await http.get(Uri.parse('http://s2tek.net:7100/api/Room/search/$customerId'));
    if (response.statusCode == 200) {
      final jsonItems = jsonDecode(response.body) as List;
      setState(() {
        _dropdownItems =
            jsonItems.map((item) => DropdownItem.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load dropdown items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 200, // Fixed height of the dropdown
      child: SingleChildScrollView(
        child: DropdownButtonFormField<DropdownItem>(
          value: _selectedItem,
          decoration: InputDecoration(
            labelText: 'Select Your Room',
            border: OutlineInputBorder(),
          ),
          items: _dropdownItems
              .take(10)
              .map(
                (item) => DropdownMenuItem<DropdownItem>(
              value: item,
              child: Text("Room Number: ${item.roomNumber}"),
            ),
          )
              .toList(),
          onChanged: (item) {
            setState(() {
              _selectedItem = item;
            });
            widget.onItemSelected(_selectedItem);
          },
        ),
        scrollDirection: Axis.vertical,
        controller: ScrollController(), // Required when using a scrollbar
      ),
    );
  }
}