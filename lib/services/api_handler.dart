import 'dart:convert';
import 'dart:developer';
import 'package:garden_app/models/garden_model.dart';
import 'package:garden_app/models/room_model.dart';
import 'package:http/http.dart' as http;
import 'package:garden_app/consts/api_consts.dart';
import 'package:garden_app/models/categories_model.dart';
import 'package:garden_app/models/products_model.dart';
//import 'package:store_app/models/users_model.dart';

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
      log("An error occured $error");
      throw error.toString();
    }
  }
  static Future<List<Room>> getAllRooms({required String limit}) async{
    List temp = await getData(
        target: "Room",
        limit: limit,
    );

    return Room.productsFromSnapshot(temp);
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
    List temp = await getData(target: "categories");
    return CategoriesModel.categoriesFromSnapshot(temp);
  }
  Future<GardenModel> createGarden(String DateTime, String GardenPackageId,String RoomId) async{
    try {
      final response = await http.post(
        Uri.parse('https://your-api.com/add-to-cart'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String , String>{
          'DateTime': DateTime,
          "GardenPackageId": GardenPackageId,
          "RoomId" : RoomId
        }),
      );
      if (response.statusCode == 200) {
        // Handle success
        print('Added to cart');
        return GardenModel.fromJson(jsonDecode(response.body));
      } else {
        // Handle error
        print('Failed to add to cart');
        throw Exception('Failed to add to cart');
      }
    } catch (e) {
      // Handle error
      print('Failed to add to cart: $e');
      throw Exception('Failed to add to cart');
    }
  }
  // static Future<List<UsersModel>> getAllUsers() async {
  //   List temp = await getData(target: "users");
  //   return UsersModel.usersFromSnapshot(temp);
  // }

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
      log("an error occured while getting product info $error");
      throw error.toString();
    }
  }
}
