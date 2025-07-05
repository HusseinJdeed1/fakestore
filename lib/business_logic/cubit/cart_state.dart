part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

class CartLoading extends CartState {
  CartLoading();
}

class CartLoaded extends CartState {
  final CartNew userCart;
  CartLoaded(this.userCart);
}

class CartError extends CartState {
  final String error;
  CartError(this.error);
}
