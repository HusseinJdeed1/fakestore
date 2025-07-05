import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user.dart';
import '../../data/repository/users_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UsersRepository usersRepository;

  List<User> allUsers = [];
  String? userToken;
  late User currentUser;
  late int? currentUserId;

  //dynamic userSignUpData;
  UserCubit(this.usersRepository) : super(UserInitial());
  Future<void> userLogIn(String username, String password) async {
    emit(UserLoggingIn());

    try {
      final token = await usersRepository.getUserToken(username, password);

      if (token != null) {
        emit(UserLoggedIn(token.token));
        userToken = token.token;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token.token);
        final user = await getUserByUsernameAndPassword(username, password);
        currentUser = user!;
        if (user != null) {
          await prefs.setString('user', jsonEncode(user.toJson()));

          emit(UserDataLoaded(user));
        } else {
          await prefs.remove('user');
          emit(UserLoggingInError("User Not Found"));
        }
      } else {
        emit(UserLoggingInError("Invalid User Name or Password"));
      }
    } catch (error) {
      emit(UserLoggingInError(error.toString()));
    }
  }

  Future<void> userSignUp(
      int? userID, String userEmail, String username, String password) async {
    emit(UserRegistration());
    try {
      final data = await usersRepository.userSignUp(
        userID,
        userEmail,
        username,
        password,
      );

      if (data != null) {
        User? user = data;
        print("----------------+");
        print(user);
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('user', jsonEncode(user?.toJson()));

        emit(UserRegistered(user));

        //  userSignUpData = data;
      } else {
        emit(UserRegistrationError("Registeration Error"));
      }
    } catch (error) {
      emit(UserRegistrationError(error.toString()));
    }
  }

  Future<List<User>> getAllUsers() async {
    final users = await usersRepository.getAllUsers();
    this.allUsers = users;
    if (kDebugMode) {
      print(allUsers.toString());
    }
    return allUsers;
  }

  Future<User?> getUserByUsernameAndPassword(
      String username, String password) async {
    if (allUsers.isEmpty) {
      allUsers = await usersRepository.getAllUsers();
    }
    try {
      currentUser = allUsers.firstWhere(
        (user) => user.username == username && user.password == password,
      );
      if (kDebugMode) {
        print(currentUser.firstname);
      }
      currentUserId = currentUser.id;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentUserId', currentUser.id.toString());
      return currentUser;
    } catch (e) {
      if (kDebugMode) print("User not found: $e");
      return null;
    }
  }

  Future<void> userDelete(String userId) async {
    emit(UserDeletingAccount());
    try {
      final success = await usersRepository.userDelete(userId);
      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove("token");
        await prefs.remove("user");

        emit(UserDeletedAccount());
      } else {
        emit(UserDeletingAccountError("Failed to delete account"));
      }
    } catch (e) {
      emit(UserDeletingAccountError(e.toString()));
    }
  }
}
