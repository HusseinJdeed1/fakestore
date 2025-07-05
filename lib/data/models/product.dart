class Product {
  late int id;
  late String title;
  late num price;
  late String description;
  late String category;
  late String image;
  late num rate;
  late num rateCount;

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    category = json['category'];
    image = json['image'];
    rate = json['rating']["rate"];
    rateCount = json['rating']["count"];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'description': description,
    'category': category,
    'image': image,
  };
}
