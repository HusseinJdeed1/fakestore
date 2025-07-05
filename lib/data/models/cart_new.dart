class CartNew {
  int? id;
  int? userId;
  String? date;
  List<CartProduct>? products;
  int? iV;

  CartNew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    date = json['date'];
    if (json['products'] != null) {
      products = <CartProduct>[];
      json['products'].forEach((v) {
        products!.add(CartProduct.fromJson(v));
      });
    }
    iV = json['__v'];
  }
  //todo: edit this function

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['userId'] = userId;
    data['date'] = date;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    // data['__v'] = iV;
    return data;
  }
}

class CartProduct {
  int? productId;
  int? quantity;

  CartProduct({this.productId, this.quantity});

  CartProduct.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['quantity'] = this.quantity;
    return data;
  }
}
