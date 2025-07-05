class UserToken {
  late String token;

  UserToken.fromJson(Map<String, dynamic> json) {
    token = json["token"];
  }
}
