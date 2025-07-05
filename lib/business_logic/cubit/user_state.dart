part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

class UserLoggingIn extends UserState {}

class UserLoggedIn extends UserState {
  final String? token;
  UserLoggedIn(this.token);
}

class UserDataLoaded extends UserState {
  final User user;
  UserDataLoaded(this.user);
}

class UserLoggingInError extends UserState {
  final String error;
  UserLoggingInError(this.error);
}

class UserRegistration extends UserState {}

class UserRegistered extends UserState {
  final User? user;
  UserRegistered(this.user);
}

class UserRegistrationError extends UserState {
  final String error;
  UserRegistrationError(this.error);
}

class UserDeleted extends UserState {
  UserDeleted();
}

class UserDeletedAccount extends UserState {
  UserDeletedAccount();
}

class UserDeletingAccount extends UserState {
  UserDeletingAccount();
}

class UserDeletingAccountError extends UserState {
  final String error;
  UserDeletingAccountError(this.error);
}
