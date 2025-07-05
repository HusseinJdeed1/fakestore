part of 'product_cubit.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;

  ProductsLoaded(this.products);
}
