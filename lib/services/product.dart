import 'dart:convert';

import 'package:garden_app/models/products_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;



Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }

}
extension IterableExtension<T> on Iterable<T> {
  Iterable<T> distinctBy(Object Function(T e) getCompareValue) {
    var result = <T>[];
    forEach((element) {
      if (!result.any((x) => getCompareValue(x) == getCompareValue(element))) {
        result.add(element);
      }
    });
    return result;
  }

  Iterable<E> mapWithIndex<E>(E Function(int index, T value) f) {
    return Iterable.generate(length).map((i) => f(i, elementAt(i)));
  }
}


class ProductController extends GetxController{
  RxList<ProductsModel> cartProducts = <ProductsModel>[].obs;
  RxInt totalPrice = 0.obs;
  bool get isEmptyCart => cartProducts.isEmpty;
  void calculateTotalPrice() {
    totalPrice.value = 0;
    for (var element in cartProducts) {
      totalPrice.value += element.price!;
    }
  }
  void addToCart(ProductsModel product) {
    //product.quantity++;
    cartProducts.add(product);
    cartProducts.assignAll(cartProducts.distinctBy((item) => item));
    calculateTotalPrice();
  }
}