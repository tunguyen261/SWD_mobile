import 'package:flutter/material.dart';

class GardenModel with ChangeNotifier{
  int? id;
  int? status;
  int? gardenPackageId;
  String? dateTime;
  int? roomId;
  List<dynamic>? requests;

  GardenModel(
      {this.id,
      this.status,
      this.gardenPackageId,
      this.dateTime,
      this.roomId,
      this.requests});

  GardenModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    status = json["status"];
    gardenPackageId = json["gardenPackageId"];
    dateTime = json["dateTime"];
    roomId = json["roomId"];
    requests = json["requests"] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["status"] = status;
    _data["gardenPackageId"] = gardenPackageId;
    _data["dateTime"] = dateTime;
    _data["roomId"] = roomId;
    if (requests != null) {
      _data["requests"] = requests;
    }
    return _data;
  }
  static List<GardenModel> gardenFromSnapshot(List gardenSnapshot) {
    return gardenSnapshot.map((data) {
      return GardenModel.fromJson(data);
    }).toList();
  }
}
