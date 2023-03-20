
class GardenDetailModel {
  int? id;
  int? status;
  int? gardenPackageId;
  String? dateTime;
  int? roomId;
  GardenPackage? gardenPackage;
  Room? room;
  List<dynamic>? requests;

  GardenDetailModel({this.id, this.status, this.gardenPackageId, this.dateTime, this.roomId, this.gardenPackage, this.room, this.requests});

  GardenDetailModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    status = json["status"];
    gardenPackageId = json["gardenPackageId"];
    dateTime = json["dateTime"];
    roomId = json["roomId"];
    gardenPackage = json["gardenPackage"] == null ? null : GardenPackage.fromJson(json["gardenPackage"]);
    room = json["room"] == null ? null : Room.fromJson(json["room"]);
    requests = json["requests"] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["status"] = status;
    _data["gardenPackageId"] = gardenPackageId;
    _data["dateTime"] = dateTime;
    _data["roomId"] = roomId;
    if(gardenPackage != null) {
      _data["gardenPackage"] = gardenPackage?.toJson();
    }
    if(room != null) {
      _data["room"] = room?.toJson();
    }
    if(requests != null) {
      _data["requests"] = requests;
    }
    return _data;
  }
}

class Room {
  int? id;
  String? roomNumber;
  int? length;
  int? width;
  int? status;
  int? buildingId;
  String? customerId;
  dynamic building;
  Customer? customer;
  dynamic garden;

  Room({this.id, this.roomNumber, this.length, this.width, this.status, this.buildingId, this.customerId, this.building, this.customer, this.garden});

  Room.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    roomNumber = json["roomNumber"];
    length = json["length"];
    width = json["width"];
    status = json["status"];
    buildingId = json["buildingId"];
    customerId = json["customerId"];
    building = json["building"];
    customer = json["customer"] == null ? null : Customer.fromJson(json["customer"]);
    garden = json["garden"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["roomNumber"] = roomNumber;
    _data["length"] = length;
    _data["width"] = width;
    _data["status"] = status;
    _data["buildingId"] = buildingId;
    _data["customerId"] = customerId;
    _data["building"] = building;
    if(customer != null) {
      _data["customer"] = customer?.toJson();
    }
    _data["garden"] = garden;
    return _data;
  }
}

class Customer {
  String? id;
  String? fullName;
  int? phone;
  String? gmail;
  int? gender;
  int? status;
  String? password;
  List<dynamic>? rooms;

  Customer({this.id, this.fullName, this.phone, this.gmail, this.gender, this.status, this.password, this.rooms});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    fullName = json["fullName"];
    phone = json["phone"];
    gmail = json["gmail"];
    gender = json["gender"];
    status = json["status"];
    password = json["password"];
    rooms = json["rooms"] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["fullName"] = fullName;
    _data["phone"] = phone;
    _data["gmail"] = gmail;
    _data["gender"] = gender;
    _data["status"] = status;
    _data["password"] = password;
    if(rooms != null) {
      _data["rooms"] = rooms;
    }
    return _data;
  }
}

class GardenPackage {
  int? id;
  String? namePack;
  String? image;
  int? length;
  int? width;
  String? description;
  int? price;
  int? status;
  int? packageTypeId;
  dynamic packageType;
  List<dynamic>? gardens;
  List<dynamic>? trees;

  GardenPackage({this.id, this.namePack, this.image, this.length, this.width, this.description, this.price, this.status, this.packageTypeId, this.packageType, this.gardens, this.trees});

  GardenPackage.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    namePack = json["namePack"];
    image = json["image"];
    length = json["length"];
    width = json["width"];
    description = json["description"];
    price = json["price"];
    status = json["status"];
    packageTypeId = json["packageTypeId"];
    packageType = json["packageType"];
    gardens = json["gardens"] ?? [];
    trees = json["trees"] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["namePack"] = namePack;
    _data["image"] = image;
    _data["length"] = length;
    _data["width"] = width;
    _data["description"] = description;
    _data["price"] = price;
    _data["status"] = status;
    _data["packageTypeId"] = packageTypeId;
    _data["packageType"] = packageType;
    if(gardens != null) {
      _data["gardens"] = gardens;
    }
    if(trees != null) {
      _data["trees"] = trees;
    }
    return _data;
  }
}