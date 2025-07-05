import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../constants/my_strings.dart';

class UserWebServices {
  late Dio dio;

  UserWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);
  }

  Future<dynamic> userLogIn(String username, String password) async {
    try {
      Response response = await dio.post(
        "auth/login",
        data: jsonEncode(
          {
            "username": username,
            "password": password,
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
          print("Login Success: ${response.data}");
        }
        return response.data;
      } else {
        if (kDebugMode) {
          print("Login Failed: ${response.statusMessage}");
        }
        return null;
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error: $error");
      }
      return;
    }
  }

  Future<dynamic> userSignUp(
      int? userID, String userEmail, String username, String password) async {
    try {
      Response response = await dio.post(
        "users",
        data: jsonEncode(
          {
            "id": userID,
            "email": userEmail,
            "username": username,
            "password": password,
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
          print("Register Success: ${response.data}");
        }
        return response.data;
      } else {
        if (kDebugMode) {
          print("Register Failed: ${response.statusMessage}");
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

  Future<List<dynamic>> getAllUsers() async {
    try {
      Response response = await dio.get("users");

      return response.data;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }

      return [];
    }
  }

  Future<bool> userDelete(String userID) async {
    try {
      Response response = await dio.delete(
        "users/$userID",
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Delete Success: ${response.data}");
        }
        return true;
      } else {
        if (kDebugMode) {
          print("Delete Failed: ${response.statusMessage}");
        }
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error: $error");
      }
      return false;
    }
  }
}
