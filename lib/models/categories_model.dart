import 'package:flutter/material.dart';

class CategoriesModel with ChangeNotifier {
  int? id;
  String? namePackageType;
  int? status;
  List<dynamic>? gardenPackages;

  CategoriesModel(
      {this.id, this.namePackageType, this.status, this.gardenPackages});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    namePackageType = json["namePackageType"];
    status = json["status"];
    gardenPackages = json["gardenPackages"] ?? [];
  }
  static List<CategoriesModel> categoriesFromSnapshot(List categoriesSnapshot) {
    return categoriesSnapshot.map((data) {
      return CategoriesModel.fromJson(data);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["namePackageType"] = namePackageType;
    _data["status"] = status;
    if (gardenPackages != null) {
      _data["gardenPackages"] = gardenPackages;
    }
    return _data;
  }
}
