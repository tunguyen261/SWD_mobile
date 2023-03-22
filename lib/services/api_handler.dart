import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garden_app/models/room_model.dart';
import 'package:http/http.dart' as http;
import 'package:garden_app/consts/api_consts.dart';
import 'package:garden_app/models/categories_model.dart';
import 'package:garden_app/models/products_model.dart';

class APIHandler {
  static Future<List<dynamic>> getData(
      {required String target, String? limit}) async {
    try {
      var uri = Uri.https(
          BASE_URL,
          "api/$target",
          target == "GardenPackage"
              ? {
                  "offset": "0",
                  "limit": limit,
                }
              : {});
      var response = await http.get(uri);

      print("responseDB: ${jsonDecode(response.body)}");
      var data = jsonDecode(response.body);
      List tempList = [];
      if (response.statusCode != 200) {
        throw data["message"];
      }
      for (var v in data) {
        tempList.add(v);
        // print("V $v \n\n");
      }
      return tempList;
    } catch (error) {
      log("An error occurred1 $error");
      throw error.toString();
    }
  }

  static Future<List<Room>> getAllRooms({required String limit}) async {
    List temp = await getData(
      target: "Room",
      limit: limit,
    );

    return Room.roomsFromSnapshot(temp);
  }

  static Future<List<ProductsModel>> getAllProducts(
      {required String limit}) async {
    List temp = await getData(
      target: "GardenPackage",
      limit: limit,
    );
    return ProductsModel.productsFromSnapshot(temp);
  }

  static Future<List<CategoriesModel>> getAllCategories() async {
    List temp = await getData(target: "PackageType");
    return CategoriesModel.categoriesFromSnapshot(temp);
  }

// lay room theo User
  static Future<List<Room>> getDataRoom() async {
    final customerId = await fetchCustomerId();
    print(BASE_URL+"/api/"+"Room/search/UserID?UserID=${customerId}");
    var response = await http.get(Uri.parse("https://lacha.s2tek.net/api/Room/search/UserID?UserID=$customerId"));
    List tempList = [];
    var data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw data["message"];
    }
    for (var v in data) {
      tempList.add(v);
    }
    return Room.roomsFromSnapshot(tempList);
  }

  static Future<String> fetchCustomerId() async {
    String? auth = FirebaseAuth.instance.currentUser?.email;
    final response = await http.get(
        Uri.parse('https://lacha.s2tek.net/api/Customer/search?name=$auth'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is List && jsonResponse.isNotEmpty) {
        final customer = jsonResponse.first;
        final id = customer["id"].toString();
        return id;
      }
    }

    throw Exception('Failed to fetch customer ID');
  }

  static Future<ProductsModel> getProductById({required String id}) async {
    try {
      var uri = Uri.https(
        BASE_URL,
        "api/GardenPackage/$id",
      );
      var response = await http.get(uri);

      // print("response ${jsonDecode(response.body)}");
      var data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return ProductsModel.fromJson(data);
    } catch (error) {
      log("an error occurred while getting product info $error");
      throw error.toString();
    }
  }
  static Future<ProductsModel> getProductSearch({required String search}) async {
    try {
      var uri = Uri.https(
        BASE_URL,
        "api/GardenPackage/search?name=$search",
      );
      var response = await http.get(uri);

      // print("response ${jsonDecode(response.body)}");
      var data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return ProductsModel.fromJson(data);
    } catch (error) {
      log("an error occurred while getting product info $error");
      throw error.toString();
    }
  }
}
