import '../models/user.dart';
import '../models/user_token.dart';
import '../web_services/users_web_services.dart';

class UsersRepository {
  final UserWebServices userWebServices;
  UsersRepository(this.userWebServices);
  Future<List<User>> getAllUsers() async {
    final users = await userWebServices.getAllUsers();
    return users.map((user) => User.fromJson(user)).toList();
  }

  Future<dynamic> userSignUp(
    int? userID,
    String userEmail,
    String username,
    String password,
  ) async {
    final userSignupData =
        await userWebServices.userSignUp(userID, userEmail, username, password);
    return User.fromJson(userSignupData);
  }

  Future<bool> userDelete(String userID) async {
    bool status = await userWebServices.userDelete(userID);
    return status;
  }

  Future<UserToken?> getUserToken(String username, String password) async {
    final userToken = await userWebServices.userLogIn(username, password);
    return UserToken?.fromJson(userToken);
  }
}
