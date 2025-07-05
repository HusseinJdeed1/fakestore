import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../constants/my_strings.dart';

class ProductsWebServices {
  late Dio dio;
  ProductsWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveTimeout: Duration(seconds: 30),
      connectTimeout: Duration(seconds: 30),
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);
  }
  Future<List<dynamic>> getAllProducts() async {
    try {
      Response response = await dio.get("products");
      if (kDebugMode) {
        //    print(response.data);
      }

      return response.data;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }

      return [];
    }
  }
}
