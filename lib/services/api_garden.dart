import 'dart:convert';
import 'dart:developer';
import 'package:garden_app/models/garden_model.dart';
import 'package:garden_app/services/api_handler.dart';
import 'package:http/http.dart' as http;

import '../models/garden_detail_model.dart';

class GardenAPI{
  static Future<List<GardenModel>> getAllGarden() async {
    final customerId = await APIHandler.fetchCustomerId();
    var response = await http.get(Uri.parse("https://lacha.s2tek.net/api/Garden/CustomerID?CustomerID=$customerId"));
    List tempList = [];
    var data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw data["message"];
    }
    for (var v in data) {
      tempList.add(v);
    }
    return GardenModel.gardenFromSnapshot(tempList);
  }
  static Future<GardenDetailModel> getGardenById({required String id}) async {
    try {
      
      var response = await http.get(Uri.parse("https://lacha.s2tek.net/api/Garden/$id"));

      print("response ${jsonDecode(response.body)}");
      var data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return GardenDetailModel.fromJson(data);
    } catch (error) {
      log("an error occurred while getting product info $error");
      throw error.toString();
    }
  }

}