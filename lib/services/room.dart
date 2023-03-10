import 'dart:convert';

import 'package:garden_app/models/room_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RoomController extends GetxController{
  RxList<Room> room =<Room>[].obs;

}