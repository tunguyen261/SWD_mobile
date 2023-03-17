class UserProfile {
  String? id;
  String? fullName;
  int? phone;
  String? gmail;
  int? gender;
  int? status;
  String? password;
  List<dynamic>? rooms;

  UserProfile({this.id, this.fullName, this.phone, this.gmail, this.gender, this.status, this.password, this.rooms});

  UserProfile.fromJson(Map<String, dynamic> json) {
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