class UserRegisteredData {
  late int id;
  UserRegisteredData.fromJson(Map<String, dynamic> json) {
    id = json["id"];
  }
}
