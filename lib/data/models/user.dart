class User {
  late int id;
  late String username;
  late String firstname;
  late String lastname;
  late String phone;
  late String email;
  late String password;

  late String city;
  late String street;
  User.fromJson(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>? ?? {};
    final name = json['name'] as Map<String, dynamic>? ?? {};

    city = address['city'] ?? "";
    street = address['street'] ?? "";
    id = json['id'] ?? 0;
    email = json['email'] ?? "";
    username = json['username'] ?? "";
    password = json['password'] ?? "";
    phone = json['phone'] ?? "";
    firstname = name['firstname'] ?? "";
    lastname = name['lastname'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      "name": {
        'firstname': firstname,
        'lastname': lastname,
      },
      'email': email,
      'username': username,
      'password': password,
      "address": {
        "city": city,
        "street": street,
      },
      "id": id,
      "phone": phone
    };
  }
}
