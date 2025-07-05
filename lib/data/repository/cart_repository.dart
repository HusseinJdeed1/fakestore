import '../models/cart.dart';
import '../web_services/cart_web_services.dart';

class CartRepository {
  final CartWebServices cartWebServices;
  CartRepository(this.cartWebServices);
  late List<dynamic> carts;
  Future<List<dynamic>> getAllCarts() async {
    final carts = await cartWebServices.getAllCarts();
    return carts.map((cart) => Cart.fromJson(cart)).toList();
  }

  Future<void> updateUserCart(
      int cartId, int userId, List<Map<String, dynamic>> products) async {
    await cartWebServices.updateUserCart(cartId, userId, products);
  }

  Future<dynamic> addEmptyCart(int cartId, int userId) async {
    await cartWebServices.addEmptyCart(userId);
  }
}
