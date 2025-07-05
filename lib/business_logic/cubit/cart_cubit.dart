import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/cart_new.dart';
import '../../data/repository/cart_new_repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartNewRepository cartNewRepository;
  late List<CartNew> allCarts;
  late CartNew? userCart;
  late List<CartProduct> cartProducts = [];
  double toralPrice = 0;
  CartCubit(this.cartNewRepository) : super(CartInitial());

  Future<CartNew?> getUserCartInfoById(int userId) async {
    emit(CartLoading());
    try {
      allCarts = await cartNewRepository.getAllCarts();
      CartNew matchingCart;
      try {
        matchingCart = allCarts.firstWhere((cart) => cart.userId == userId);
      } catch (_) {
        matchingCart = await cartNewRepository.addEmptyCart(userId);
      }
      userCart = matchingCart;
      await saveCartToLocal();
      emit(CartLoaded(matchingCart));
      print("8888888888");
      print(userCart!.products);
      print("8888888888");
      emit(CartLoaded(matchingCart));

      return userCart;
    } //cartProducts = userCart.products!;
    catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(CartError(e.toString()));
      return null;
    }
  }

  void addProductToCart(int productId, int quantity) async {
    CartProduct product =
        CartProduct.fromJson({"productId": productId, "quantity": quantity});
    userCart!.products!.add(product);
    await saveCartToLocal();
    emit(CartLoaded(userCart!));

    print("product added successfully$cartProducts");
  }

  void removeProductFromCart(productId) async {
    userCart!.products!
        .removeWhere((product) => product.productId == productId);
    await saveCartToLocal();
    emit(CartLoaded(userCart!));
  }

  Future<void> saveCartToLocal() async {
    final prefs = await SharedPreferences.getInstance();

    if (userCart != null) {
      final cartJson = userCart!.toJson();
      final cartString = jsonEncode(cartJson);

      await prefs.setString('userCart', cartString);

      if (kDebugMode) print("Cart saved to SharedPreferences");
    }
  }

  Future<void> loadCartFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('userCart');

    if (cartString != null) {
      final cartJson = jsonDecode(cartString);
      userCart = CartNew.fromJson(cartJson);
      cartProducts = userCart!.products!;
      emit(CartLoaded(userCart!));

      if (kDebugMode) {
        print("Cart loaded from SharedPreferences ");
        print(userCart!.products);
      }
    } else {
      emit(CartInitial());
      if (kDebugMode) print("No cart found in SharedPreferences ");
    }
  }
}
