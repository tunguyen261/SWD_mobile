import 'package:flutter/cupertino.dart';

class Room with ChangeNotifier{
  int? id;
  String? roomNumber;
  int? status;
  int? buildingId;
  String? customerId;

  Room({this.id, this.roomNumber, this.status, this.buildingId, this.customerId});

  Room.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    roomNumber = json["roomNumber"];
    status = json["status"];
    buildingId = json["buildingId"];
    customerId = json["customerId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["roomNumber"] = roomNumber;
    _data["status"] = status;
    _data["buildingId"] = buildingId;
    _data["customerId"] = customerId;
    return _data;
  }
  static List<Room> productsFromSnapshot(List roomSnapshot) {
    return roomSnapshot.map((data) {
      return Room.fromJson(data);
    }).toList();
  }
}