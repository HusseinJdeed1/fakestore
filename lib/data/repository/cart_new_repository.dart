import 'package:flutter/foundation.dart';

import '../models/cart_new.dart';
import '../web_services/cart_web_services.dart';

class CartNewRepository {
  final CartWebServices cartWebServices;
  CartNewRepository(this.cartWebServices);
  late List<CartProduct> cartProducts = [];
  late CartNew userCart;
  Future<List<CartNew>> getAllCarts() async {
    final List<dynamic> carts = await cartWebServices.getAllCarts();
    return carts.map((cart) => CartNew.fromJson(cart)).toList();
  }

  Future<CartNew> updateUserCart(
      int cartId, int userId, List<Map<String, dynamic>> products) async {
    final cart = await cartWebServices.updateUserCart(cartId, userId, products);
    return CartNew.fromJson(cart);
  }

  Future<dynamic> addEmptyCart(int userId) async {
    final responseMap = await cartWebServices.addEmptyCart(userId);
    final newCart = CartNew.fromJson(responseMap);
    userCart = newCart;
    cartProducts = userCart.products!;
    if (kDebugMode) {
      print(newCart);
      print(cartProducts);
    }
    return newCart;
  }

  void addProductToCart(int productId, int quantity) {
    CartProduct product =
        CartProduct.fromJson({"productId": productId, "quantity": quantity});
    cartProducts.add(product);
    if (kDebugMode) {
      print(cartProducts[0].productId);
    }
  }

  void removeProductFromCart(int productId) {
    cartProducts.removeWhere((product) => product.productId == productId);
    if (kDebugMode) {
      print(cartProducts);
    }
  }
}
