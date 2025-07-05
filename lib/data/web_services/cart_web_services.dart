import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../constants/my_strings.dart';

class CartWebServices {
  late Dio dio;
  CartWebServices() {
    BaseOptions options = BaseOptions(
        baseUrl: baseUrl,
        receiveTimeout: Duration(seconds: 30),
        connectTimeout: Duration(seconds: 30),
        receiveDataWhenStatusError: true);

    dio = Dio(options);
  }
  Future<dynamic> getAllCarts() async {
    try {
      Response response = await dio.get("carts");
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Loaded Carts: ${response.data}");
        }
        return response.data as List;
      } else {
        if (kDebugMode) {
          print("Failed to load Carts: ${response.data}");
        }
        return [];
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error while getting carts: ${error.toString()}");
      }
      return [];
    }
  }

  Future<dynamic> getSingleCart(int cartId) async {
    try {
      Response response = await dio.get("carts/$cartId");
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Cart with ID:$cartId loaded successfully: ${response.data}");
        }
        return response.data;
      } else {
        if (kDebugMode) {
          print("Cart with ID:$cartId loaded failed: ${response.data}");
        }
        return [];
      }
    } catch (error) {
      if (kDebugMode) {
        print("Cart with ID:$cartId loaded failed: ${error.toString()}");
      }
      return [];
    }
  }

  Future<dynamic> updateUserCart(
      int cartId, int userId, List<Map<String, dynamic>> products) async {
    try {
      Response response = await dio.put(
        "carts/$cartId",
        data: jsonEncode(
          {
            "id": cartId,
            "userId": userId,
            "products": products,
          },
        ),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("-------------------");
          print("Success to update cart: ${response.data}");
        }
        return response.data;
      } else {
        if (kDebugMode) {
          print("Failed to update cart: ${response.statusMessage}");
        }
        return;
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error: $error");
      }
      return;
    }
  }

  Future<dynamic> addEmptyCart(int userId) async {
    try {
      Response response = await dio.post(
        "carts",
        data: jsonEncode(
          {
            // "id": cartId,
            "userId": userId,
            "products": [],
          },
        ),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("-------------------");
          print("Success to create cart: ${response.data}");
        }
        return response.data;
      } else {
        if (kDebugMode) {
          print("Failed to create cart: ${response.statusMessage}");
        }
        return;
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error: $error");
      }
      return;
    }
  }
}
