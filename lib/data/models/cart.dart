class Cart {
  late int id;
  late int userId;
  late List<dynamic> products;

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    products = (json['products'] as List);
    // .map((product) => Product.fromJson(product))
    // .toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'products': products.map((product) => product.toJson()).toList(),
      };
}
