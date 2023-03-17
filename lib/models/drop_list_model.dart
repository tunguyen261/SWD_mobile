class DropdownItem {
  int id;
  String roomNumber;

  DropdownItem({required this.id, required this.roomNumber});

  factory DropdownItem.fromJson(Map<String, dynamic> json) {
    return DropdownItem(
      id: json['id'],
      roomNumber: json['roomNumber'],
    );
  }
}
