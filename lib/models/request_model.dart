
import 'package:flutter/material.dart';

class RequestModel with ChangeNotifier{
  int? id;
  String? description;
  int? status;
  int? gardenId;
  List<dynamic>? treeCares;

  RequestModel({this.id, this.description, this.status, this.gardenId, this.treeCares});

  RequestModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    description = json["description"];
    status = json["status"];
    gardenId = json["gardenId"];
    treeCares = json["treeCares"] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["description"] = description;
    _data["status"] = status;
    _data["gardenId"] = gardenId;
    if(treeCares != null) {
      _data["treeCares"] = treeCares;
    }
    return _data;
  }
  static List<RequestModel> requestFromSnapshot(List requestSnapshot) {
    return requestSnapshot.map((data) {
      return RequestModel.fromJson(data);
    }).toList();
  }
}